class Release < Formula
  desc ""
  homepage "https://github.com/smartcrabai/release"
  version "0.1.7"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/smartcrabai/release/releases/download/v0.1.7/release-aarch64-apple-darwin.tar.xz"
    sha256 "a7190cb408d6fbc3f6a4073bca40889ede5914c8a43060ae199940f35c1e47cd"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/smartcrabai/release/releases/download/v0.1.7/release-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6836403d20bf020b8e54020affff66afdb6533562cc269e7335061014e46e1cd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartcrabai/release/releases/download/v0.1.7/release-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0205947d2e5e52ab2d8245e9c921ff074668e81fc066b8dff4de07499d2620d9"
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
