class GluonCli < Formula
  desc "CLI for the gluon framework"
  homepage "https://github.com/smartcrabai/gluon"
  version "0.1.3"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/smartcrabai/gluon/releases/download/v0.1.3/gluon-cli-aarch64-apple-darwin.tar.xz"
    sha256 "af73a82ebd35e52b343b64dda778fa549fc4531bd0a789b6f0daea42da461ba7"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/smartcrabai/gluon/releases/download/v0.1.3/gluon-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ab9f61ed86e369c73e70f91b367a73367111226608aeabd54d18c5125b1f187d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartcrabai/gluon/releases/download/v0.1.3/gluon-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4da28674ef99e6668a11090e933f72a9cbdcb775dd8fc7bd7279177b5ac9fda3"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-pc-windows-gnu":    {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "gluon"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "gluon"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "gluon"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
