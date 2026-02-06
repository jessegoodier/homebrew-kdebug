class Kdebug < Formula
  include Language::Python::Virtualenv

  desc "Universal Kubernetes Debug Container Utility"
  homepage "https://github.com/jessegoodier/kdebug"
  url "https://files.pythonhosted.org/packages/a3/f0/17f68fa5925bbe38755d74eb55e32a301a52bb03d11c07bd691bd944985e/kdebug-0.3.1.tar.gz"
  sha256 "057fdee8a9370f420a6616d045552e5d1462c1e3015b1628ac81ac514c4fb293"
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
