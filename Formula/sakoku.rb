class Sakoku < Formula
  desc "A fast CLI tool to detect non-ASCII bytes in source files"
  homepage "https://github.com/smartcrabai/sakoku"
  version "0.2.3"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/smartcrabai/sakoku/releases/download/v0.2.3/sakoku-aarch64-apple-darwin.tar.xz"
    sha256 "6295539e76644b52d5207566a86df3593345fb36740f06b14475ddf5603a9a45"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/smartcrabai/sakoku/releases/download/v0.2.3/sakoku-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b487c84f21fa8689c064977b47fa6e7602ebf0514121b74950a95c1d1b087daf"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartcrabai/sakoku/releases/download/v0.2.3/sakoku-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4f5953b8cf838131e720414db92cff1edd555ee5b529b4c999ebd8006a5c949e"
    end
  end
  license "Apache-2.0"

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
    bin.install "sakoku" if OS.mac? && Hardware::CPU.arm?
    bin.install "sakoku" if OS.linux? && Hardware::CPU.arm?
    bin.install "sakoku" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
