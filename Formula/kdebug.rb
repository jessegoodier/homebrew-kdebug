class Kdebug < Formula
  include Language::Python::Virtualenv

  desc "Universal Kubernetes Debug Container Utility"
  homepage "https://github.com/jessegoodier/kdebug"
  url "https://files.pythonhosted.org/packages/33/1d/2e5e0fc58bd8debbaafd80929712a3b45f9dcdf14d23da860916c431723c/kdebug-0.3.4.tar.gz"
  sha256 "dfc811aa41c946e6a16aceb54507ab11ceac46673b276bac9c846cb553a0c10f"
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
