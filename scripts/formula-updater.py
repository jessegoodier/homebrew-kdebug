#!/usr/bin/env python3
"""
Formula Updater Script for kdebug Homebrew Formula

Fetches PyPI package information and generates/updates the Homebrew formula.
Simplified version for kdebug (no external dependencies).
"""

import argparse
import json
import os
import sys
import urllib.request
import urllib.error


PACKAGE_NAME = "kdebug"
PYPI_URL = f"https://pypi.org/pypi/{PACKAGE_NAME}"


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


def get_version_info(version: str) -> dict:
    """Get source distribution URL and SHA256 for a specific version."""
    data = fetch_json(f"{PYPI_URL}/{version}/json")

    # Find source distribution (sdist)
    for release in data["urls"]:
        if release["packagetype"] == "sdist":
            return {
                "version": version,
                "url": release["url"],
                "sha256": release["digests"]["sha256"],
            }

    print(f"Error: No source distribution found for version {version}", file=sys.stderr)
    sys.exit(1)


def generate_formula(info: dict) -> str:
    """Generate the Homebrew formula content."""
    return f'''class Kdebug < Formula
  include Language::Python::Virtualenv

  desc "Universal Kubernetes Debug Container Utility"
  homepage "https://github.com/jessegoodier/kdebug"
  url "{info['url']}"
  sha256 "{info['sha256']}"
  license "MIT"

  depends_on "python@3.13"

  def install
    virtualenv_install_with_resources
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
                f.write(f"{key}={value}\n")

    # Also print for debugging
    for key, value in info.items():
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
        print(json.dumps(info, indent=2))
    elif args.output_format == "env":
        output_env(info)
    else:
        print(f"Version: {info['version']}")
        print(f"URL: {info['url']}")
        print(f"SHA256: {info['sha256']}")

    # Write formula if requested
    if args.output_formula:
        formula = generate_formula(info)
        os.makedirs(os.path.dirname(args.output_formula) or ".", exist_ok=True)
        with open(args.output_formula, "w") as f:
            f.write(formula)
        print(f"Formula written to {args.output_formula}")


if __name__ == "__main__":
    main()
