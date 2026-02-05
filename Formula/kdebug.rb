class Kdebug < Formula
  include Language::Python::Virtualenv

  desc "Universal Kubernetes Debug Container Utility"
  homepage "https://github.com/jessegoodier/kdebug"
  url "https://files.pythonhosted.org/packages/9d/b3/f25d17243505769bcf417a1bd8e3e9ec25b688f382146955a23b0dfa978a/kdebug-0.3.0.tar.gz"
  sha256 "033582953b55271c22b8223cd40de1e59cc7e7d9047597443e96edc4c5126ab1"
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
