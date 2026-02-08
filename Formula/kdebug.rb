class Kdebug < Formula
  include Language::Python::Virtualenv

  desc "Universal Kubernetes Debug Container Utility"
  homepage "https://github.com/jessegoodier/kdebug"
  url "https://files.pythonhosted.org/packages/1b/d4/094842d7bf5ce84e660867b65aba167daddf41fe11277f3577d496439ecf/kdebug-0.4.0.tar.gz"
  sha256 "20f7323706418e481d47839fbc2c97689c950e0a7dfd9cc79d4dfb892e88b69b"
  license "MIT"

  depends_on "python@3.13"

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"kdebug", "--completions")
  end

  test do
    assert_match "kdebug", shell_output("#{bin}/kdebug --version")
  end
end
