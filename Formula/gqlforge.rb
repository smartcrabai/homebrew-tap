class Gqlforge < Formula
  desc "A high-performance GraphQL runtime"
  homepage "https://gqlforge.pages.dev"
  version "0.1.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/smartcrabai/gqlforge/releases/download/v0.1.7/gqlforge-aarch64-apple-darwin.tar.xz"
      sha256 "9699c811da5b2c821b064a45bb8a3abcbb2c3f94ae4faf836c3c95c5504956d9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartcrabai/gqlforge/releases/download/v0.1.7/gqlforge-x86_64-apple-darwin.tar.xz"
      sha256 "b767ec7cc3af3bc1b196f2b248ace43cdbfb6b10c3062e2d906bde2c81ac2201"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/smartcrabai/gqlforge/releases/download/v0.1.7/gqlforge-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6436fac4f4090907119a44dd5a7fdc059b4a68ce9e137506883bd620d3363e24"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartcrabai/gqlforge/releases/download/v0.1.7/gqlforge-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "bf27673aa302f8a4bd0f64a90bbea606ecf121ac6b6c077dbb4ea68b5d019783"
    end
  end
  license "Apache-2.0"

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
    bin.install "gqlforge" if OS.mac? && Hardware::CPU.arm?
    bin.install "gqlforge" if OS.mac? && Hardware::CPU.intel?
    bin.install "gqlforge" if OS.linux? && Hardware::CPU.arm?
    bin.install "gqlforge" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
