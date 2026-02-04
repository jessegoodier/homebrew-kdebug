class Kdebug < Formula
  include Language::Python::Virtualenv

  desc "Universal Kubernetes Debug Container Utility"
  homepage "https://github.com/jessegoodier/kdebug"
  url "https://files.pythonhosted.org/packages/99/27/9e90fa109336dc3047ac463ccedc9cf501abf6ed3c09b0738a781405d192/kdebug-0.2.2.tar.gz"
  sha256 "89722f5a564059407f338c1d0e57eab575dae4149a4f743ed7a24745e14af3d3"
  license "MIT"

  depends_on "python@3.13"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "kdebug", shell_output("#{bin}/kdebug --version")
  end
end
