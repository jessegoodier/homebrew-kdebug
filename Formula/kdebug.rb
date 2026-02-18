class Kdebug < Formula
  include Language::Python::Virtualenv

  desc "Universal Kubernetes Debug Container Utility"
  homepage "https://github.com/jessegoodier/kdebug"
  url "https://files.pythonhosted.org/packages/86/20/8755cbb77f839d4ff472098867abe5c8dd252222fa92b4c2166401714e70/kdebug-0.5.0.tar.gz"
  sha256 "4ec043c85362aab1b7ba94464cb67aa618520512f496d0655e40998b48a2bc19"
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
