class Kdebug < Formula
  desc "Universal Kubernetes Debug Container Utility"
  homepage "https://github.com/jessegoodier/homebrew-kdebug"
  url "https://github.com/jessegoodier/homebrew-kdebug/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "1aab0c4769cc3b00d8dc93e9e403537b03511e82e68bd598c9d93967cc389e7d"
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
