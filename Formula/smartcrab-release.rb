class SmartcrabRelease < Formula
  desc "A small Rust CLI for bumping versions, tagging releases, and publishing packages."
  homepage "https://github.com/smartcrabai/release"
  version "0.1.10"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/smartcrabai/release/releases/download/v0.1.10/smartcrab-release-aarch64-apple-darwin.tar.xz"
    sha256 "1cbe6b3b938cda1a1437a4a2e5f55f96d71e9c352f6b03b8efc270ec78a3e084"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/smartcrabai/release/releases/download/v0.1.10/smartcrab-release-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "67e63e355c98a74b95ec261a0c48a4fd7086685581e279d96f32fdc84025b46b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartcrabai/release/releases/download/v0.1.10/smartcrab-release-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1d681b309d3a2dfd154eaa02030a1212f3a3fd4c417f0103f1d557c9174d3b8b"
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
