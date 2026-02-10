class Kdebug < Formula
  include Language::Python::Virtualenv

  desc "Universal Kubernetes Debug Container Utility"
  homepage "https://github.com/jessegoodier/kdebug"
  url "https://files.pythonhosted.org/packages/c4/d7/5a6b967a2b7990b13ae35226c9754b6deda76c7a9d742508ebc38f7e12b0/kdebug-0.4.1.tar.gz"
  sha256 "35a802cb0e395e588dd3a112a294b82e3af693fe96f37d025123d063552fa8d3"
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
