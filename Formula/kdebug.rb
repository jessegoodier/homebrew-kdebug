class Kdebug < Formula
  include Language::Python::Virtualenv

  desc "Universal Kubernetes Debug Container Utility"
  homepage "https://github.com/jessegoodier/kdebug"
  url "https://files.pythonhosted.org/packages/49/fc/1778b8fb8de30981ccd1eaf734a34557fa160b74c96033bbf1bbf88f5720/kdebug-0.6.7.tar.gz"
  sha256 "66789a6c8b918997b3719032de81f9ddbde4e599ecd96255c995c62794e2eccf"
  license "MIT"

  depends_on "python@3.13"

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/5b/f5/4ec618ed16cc4f8fb3b701563655a69816155e79e24a17b651541804721d/markdown_it_py-4.0.0.tar.gz"
    sha256 "cb0a2b4aa34f932c007117b194e945bd74e0ec24133ceb5bac59009cda1cb9f3"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/b3/c6/f3b320c27991c46f43ee9d856302c70dc2d0fb2dba4842ff739d5f46b393/rich-14.3.3.tar.gz"
    sha256 "b8daa0b9e4eef54dd8cf7c86c03713f53241884e814f4e2f5fb342fe520f639b"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"kdebug", "--completions")
  end

  test do
    assert_match "kdebug", shell_output("#{bin}/kdebug --version")
  end
end
