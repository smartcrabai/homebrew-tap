class Release < Formula
  desc ""
  homepage "https://github.com/smartcrabai/release"
  version "0.1.4"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/smartcrabai/release/releases/download/v0.1.4/release-aarch64-apple-darwin.tar.xz"
    sha256 "c9d378e236aefb5eb1c7845177731f8daff6c2b1289e9ac03f900a722d16756a"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/smartcrabai/release/releases/download/v0.1.4/release-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "fc8f43c0275d96c4ed2db8ebe64132f18b069bb68c71095a22979c8ec26bebd1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartcrabai/release/releases/download/v0.1.4/release-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "048ed856bc44ea46647d2da1460eb52fcf82f14223449629fb883809ee431f57"
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
    bin.install "release" if OS.mac? && Hardware::CPU.arm?
    bin.install "release" if OS.linux? && Hardware::CPU.arm?
    bin.install "release" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
