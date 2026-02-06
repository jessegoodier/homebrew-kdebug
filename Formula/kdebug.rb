class Kdebug < Formula
  include Language::Python::Virtualenv

  desc "Universal Kubernetes Debug Container Utility"
  homepage "https://github.com/jessegoodier/kdebug"
  url "https://files.pythonhosted.org/packages/18/cf/8349aa65a67db69f10b113114e2087f8d4a91b2c5d5f32dbb501ff69d475/kdebug-0.3.3.tar.gz"
  sha256 "437b9fef184e67287e43afa56c7c2b06027395e66788d49578354766de731773"
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
