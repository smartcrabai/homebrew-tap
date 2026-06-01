class Sakoku < Formula
  desc "A fast CLI tool to detect non-ASCII bytes in source files"
  homepage "https://github.com/smartcrabai/sakoku"
  version "0.2.2"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/smartcrabai/sakoku/releases/download/v0.2.2/sakoku-aarch64-apple-darwin.tar.xz"
    sha256 "4267550681f52dfc69be6de11ea923cdd59c2b8c56d64e012fa886aa95915f98"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/smartcrabai/sakoku/releases/download/v0.2.2/sakoku-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "57d33ce32c54e79928221a8295aeeceef9ba55843656d918aee60592d916f9ca"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartcrabai/sakoku/releases/download/v0.2.2/sakoku-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "fb163c9ba877657cc42e49cc6dee3c56820dc227c4b97446b1a96266bf506052"
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
