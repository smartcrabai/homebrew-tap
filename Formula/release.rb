class Release < Formula
  desc ""
  homepage "https://github.com/smartcrabai/release"
  version "0.1.3"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/smartcrabai/release/releases/download/v0.1.3/release-aarch64-apple-darwin.tar.xz"
    sha256 "7fb0225186e714cbc964d2625f49b1e95ece98814a58256ca1920cabe3620960"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/smartcrabai/release/releases/download/v0.1.3/release-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7b490ad5ee5b2943f971355172a0b9859328347205168595da7c5595b4bbcb7f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartcrabai/release/releases/download/v0.1.3/release-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "925b8822ef6ddce527f9fdd910a533b6bdd7dd12c67ff164e7d60780ae79d9b4"
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
