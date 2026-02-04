class Kdebug < Formula
  include Language::Python::Virtualenv

  desc "Universal Kubernetes Debug Container Utility"
  homepage "https://github.com/jessegoodier/kdebug"
  url "https://files.pythonhosted.org/packages/52/78/40f831751fa455029d031789ee8941a7f7b6cbdb7208822b282979ba613a/kdebug-0.2.3.tar.gz"
  sha256 "18c61938f1b411694c791d07385d64bc0f811d5f1c1a1cb8b1edf2a536cdb7f7"
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
