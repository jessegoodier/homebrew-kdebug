class Kdebug < Formula
  desc "Universal Kubernetes Debug Container Utility"
  homepage "https://github.com/jessegoodier/homebrew-kdebug"
  url "https://github.com/jessegoodier/kdebug/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "3d439253304d37ca32b0e6cf42a11c5f796dedf33b77e49c8abcc91e9ac21c60"
  license "MIT"
  version "0.1.0"

  depends_on "python@3.11"
  depends_on "kubectl"

  def install
    bin.install "bin/kdebug"
  end

  test do
    assert_match "Universal Kubernetes Debug Container Utility", shell_output("#{bin}/kdebug --help")
  end
end

# Made with Bob
