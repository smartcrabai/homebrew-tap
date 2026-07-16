class GqlforgeTypedefs < Formula
  desc "The gqlforge-typedefs application"
  version "0.1.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/smartcrabai/gqlforge/archive/refs/tags/v0.1.8.tar.gz"
      sha256 "32ca3d9fd452ca848011d751d70c5c9f66b0c42814fda3d6b82d1175bbd948b5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartcrabai/gqlforge/releases/download/v0.1.7/gqlforge-typedefs-x86_64-apple-darwin.tar.xz"
      sha256 "0a42671a0b2a3604ac92ec6f4ed3f05aa3405b0972179ca0482ec65d7750f185"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/smartcrabai/gqlforge/releases/download/v0.1.7/gqlforge-typedefs-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "06f6aab2f15440a7b7db618b9f2b978d9b29a592f79fd2ac6025bef2ecd8880a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartcrabai/gqlforge/releases/download/v0.1.7/gqlforge-typedefs-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7d992bacbfea2a2011db3f9eb1d7dc00bfea5caf577bfe9938ff07dee568cb3f"
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
