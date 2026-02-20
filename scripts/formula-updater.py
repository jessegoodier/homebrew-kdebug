#!/usr/bin/env python3
"""
Formula Updater Script for kdebug Homebrew Formula

Fetches PyPI package information and generates/updates the Homebrew formula,
including resource blocks for all Python dependencies.
"""

import argparse
import json
import os
import re
import sys
import urllib.request
import urllib.error


PACKAGE_NAME = "kdebug"
PYPI_URL = f"https://pypi.org/pypi/{PACKAGE_NAME}"
PYTHON_VERSION = "3.13"


def fetch_json(url: str) -> dict:
    """Fetch JSON from URL using stdlib only."""
    try:
        with urllib.request.urlopen(url, timeout=30) as response:
            return json.loads(response.read().decode())
    except urllib.error.URLError as e:
        print(f"Error fetching {url}: {e}", file=sys.stderr)
        sys.exit(1)
    except json.JSONDecodeError as e:
        print(f"Error parsing JSON: {e}", file=sys.stderr)
        sys.exit(1)


def get_latest_version() -> str:
    """Get the latest version from PyPI."""
    data = fetch_json(f"{PYPI_URL}/json")
    return data["info"]["version"]


def get_package_info(package: str, version: str = None) -> dict:
    """Get source distribution URL, SHA256, and requirements for a package version."""
    if version:
        url = f"https://pypi.org/pypi/{package}/{version}/json"
    else:
        url = f"https://pypi.org/pypi/{package}/json"

    data = fetch_json(url)
    actual_version = data["info"]["version"]
    requires_dist = data["info"].get("requires_dist") or []

    for release in data["urls"]:
        if release["packagetype"] == "sdist":
            return {
                "name": package,
                "version": actual_version,
                "url": release["url"],
                "sha256": release["digests"]["sha256"],
                "requires_dist": requires_dist,
            }

    print(f"Error: No source distribution found for {package} {actual_version}", file=sys.stderr)
    sys.exit(1)


def parse_requirement(req: str) -> tuple[str, str] | None:
    """
    Parse a requirement string and return (package_name, version_spec) or None
    if the requirement is extras-only (should be skipped).

    Returns None for extras-only requirements like:
      'foo; extra == "bar"'
    """
    # Skip extras-only requirements
    if re.search(r';\s*extra\s*==', req):
        return None

    # Strip environment markers (non-extras)
    req = re.split(r';\s*(?!extra)', req)[0].strip()

    # Extract package name (stop at version specifiers or extras)
    match = re.match(r'^([A-Za-z0-9]([A-Za-z0-9._-]*[A-Za-z0-9])?)', req)
    if not match:
        return None

    name = match.group(1)
    version_spec = req[len(name):].strip()
    return name, version_spec


def resolve_dependencies(package: str, version: str, seen: set = None) -> list[dict]:
    """
    Recursively resolve all non-extras Python dependencies for a package.
    Returns a list of resource dicts (excluding the main package itself).
    """
    if seen is None:
        seen = set()

    info = get_package_info(package, version)
    resources = []

    for req_str in info.get("requires_dist", []):
        parsed = parse_requirement(req_str)
        if parsed is None:
            continue

        dep_name, _ = parsed
        dep_key = dep_name.lower().replace("-", "_")

        if dep_key in seen:
            continue
        seen.add(dep_key)

        print(f"  Resolving dependency: {dep_name}", file=sys.stderr)
        dep_info = get_package_info(dep_name)
        resources.append(dep_info)

        # Recurse into transitive dependencies
        sub_resources = resolve_dependencies(dep_name, dep_info["version"], seen)
        resources.extend(sub_resources)

    return resources


def get_version_info(version: str) -> dict:
    """Get source distribution URL and SHA256 for a specific version."""
    return get_package_info(PACKAGE_NAME, version)


def generate_resources_block(resources: list[dict]) -> str:
    """Generate the resource blocks for the formula."""
    if not resources:
        return ""

    lines = []
    for res in sorted(resources, key=lambda r: r["name"].lower()):
        lines.append(f'  resource "{res["name"]}" do')
        lines.append(f'    url "{res["url"]}"')
        lines.append(f'    sha256 "{res["sha256"]}"')
        lines.append(f'  end')
        lines.append("")

    return "\n".join(lines)


def generate_formula(info: dict, resources: list[dict] = None) -> str:
    """Generate the Homebrew formula content."""
    resources_section = ""
    if resources:
        resources_block = generate_resources_block(resources)
        if resources_block:
            resources_section = "\n" + resources_block

    return f'''class Kdebug < Formula
  include Language::Python::Virtualenv

  desc "Universal Kubernetes Debug Container Utility"
  homepage "https://github.com/jessegoodier/kdebug"
  url "{info['url']}"
  sha256 "{info['sha256']}"
  license "MIT"

  depends_on "python@{PYTHON_VERSION}"
{resources_section}
  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"kdebug", "--completions")
  end

  test do
    assert_match "kdebug", shell_output("#{{bin}}/kdebug --version")
  end
end
'''


def output_env(info: dict):
    """Output in GitHub Actions environment format."""
    github_output = os.environ.get("GITHUB_OUTPUT")
    if github_output:
        with open(github_output, "a") as f:
            for key, value in info.items():
                if not isinstance(value, (list, dict)):
                    f.write(f"{key}={value}\n")

    # Also print for debugging
    for key, value in info.items():
        if not isinstance(value, (list, dict)):
            print(f"{key}={value}")


def main():
    parser = argparse.ArgumentParser(description="Update kdebug Homebrew formula")

    version_group = parser.add_mutually_exclusive_group(required=True)
    version_group.add_argument("--version", help="Specific version to use")
    version_group.add_argument("--fetch-version-from-pypi", action="store_true",
                               help="Fetch latest version from PyPI")

    parser.add_argument("--output-format", choices=["json", "env", "human"],
                        default="human", help="Output format")
    parser.add_argument("--output-formula", help="Write formula to file")

    args = parser.parse_args()

    # Get version
    if args.fetch_version_from_pypi:
        version = get_latest_version()
        print(f"Latest PyPI version: {version}")
    else:
        version = args.version.lstrip("v")  # Strip 'v' prefix if present

    # Get version info
    info = get_version_info(version)

    # Output info
    if args.output_format == "json":
        print(json.dumps({k: v for k, v in info.items() if not isinstance(v, (list, dict))}, indent=2))
    elif args.output_format == "env":
        output_env(info)
    else:
        print(f"Version: {info['version']}")
        print(f"URL: {info['url']}")
        print(f"SHA256: {info['sha256']}")

    # Write formula if requested
    if args.output_formula:
        print(f"Resolving dependencies for {PACKAGE_NAME} {version}...", file=sys.stderr)
        resources = resolve_dependencies(PACKAGE_NAME, version)
        print(f"Found {len(resources)} dependencies.", file=sys.stderr)

        formula = generate_formula(info, resources)
        os.makedirs(os.path.dirname(args.output_formula) or ".", exist_ok=True)
        with open(args.output_formula, "w") as f:
            f.write(formula)
        print(f"Formula written to {args.output_formula}")


if __name__ == "__main__":
    main()
