class Kdebug < Formula
  include Language::Python::Virtualenv

  desc "Universal Kubernetes Debug Container Utility"
  homepage "https://github.com/jessegoodier/kdebug"
  url "https://files.pythonhosted.org/packages/c2/f8/05ecc8c2d944aad6ddb2b470a1a96d138667e6817d7faddb670d476f0f23/kdebug-0.3.2.tar.gz"
  sha256 "f6abc0a6d06ce570d216243bbfdb1ecff300303026bba7bcc9d0dcc790352255"
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
