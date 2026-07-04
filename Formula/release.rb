class Release < Formula
  desc ""
  homepage "https://github.com/smartcrabai/release"
  version "0.1.8"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/smartcrabai/release/releases/download/v0.1.8/release-aarch64-apple-darwin.tar.xz"
    sha256 "53702f6ba3b5f5385390369fd28c0d60145e4d4f893c33658850d24c846b4d89"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/smartcrabai/release/releases/download/v0.1.8/release-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "bc7a4cdd344ba6330f1ebd0ab4f899d853a2afc6aedd3b092f8a32306af97bab"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartcrabai/release/releases/download/v0.1.8/release-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b1db355de74572aefe8f196f915d27085b518e07b5c7504f37c1b3a4269615c9"
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
