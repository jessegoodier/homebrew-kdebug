class Kdebug < Formula
  include Language::Python::Virtualenv

  desc "Universal Kubernetes Debug Container Utility"
  homepage "https://github.com/jessegoodier/kdebug"
  url "https://files.pythonhosted.org/packages/source/k/kdebug/kdebug-0.1.0.tar.gz"
  sha256 "PLACEHOLDER"
  license "MIT"

  depends_on "python@3.13"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "kdebug", shell_output("#{bin}/kdebug --version")
  end
end
