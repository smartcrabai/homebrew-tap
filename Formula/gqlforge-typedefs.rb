class GqlforgeTypedefs < Formula
  desc "The gqlforge-typedefs application"
  version "0.1.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/smartcrabai/gqlforge/releases/download/v0.1.6/gqlforge-typedefs-aarch64-apple-darwin.tar.xz"
      sha256 "04dcdd8a260f3d099921ae0263a226a9d2751204996bce35c358640bd5b58168"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartcrabai/gqlforge/releases/download/v0.1.6/gqlforge-typedefs-x86_64-apple-darwin.tar.xz"
      sha256 "1679f867c1055261c7d43085f62a8f04241942077bedf8000eb2e313e9b6a737"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/smartcrabai/gqlforge/releases/download/v0.1.6/gqlforge-typedefs-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5bdb7d3381758df0cbf786093e784929e0baac52319ee264e6f43eedbf43c058"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartcrabai/gqlforge/releases/download/v0.1.6/gqlforge-typedefs-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ac282ef638aebaf6a974253b23ca4f2f52b9d19ce724d8f289010c562f9dce97"
    end
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
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
    bin.install "gqlforge-typedefs" if OS.mac? && Hardware::CPU.arm?
    bin.install "gqlforge-typedefs" if OS.mac? && Hardware::CPU.intel?
    bin.install "gqlforge-typedefs" if OS.linux? && Hardware::CPU.arm?
    bin.install "gqlforge-typedefs" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
