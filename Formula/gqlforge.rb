class Gqlforge < Formula
  desc "A high-performance GraphQL runtime"
  homepage "https://gqlforge.pages.dev"
  version "0.1.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/smartcrabai/gqlforge/releases/download/v0.1.6/gqlforge-aarch64-apple-darwin.tar.xz"
      sha256 "0e1ad188e3455bb0a5999fab778c57206148f8411facec48d66531ceae2fffa2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartcrabai/gqlforge/releases/download/v0.1.6/gqlforge-x86_64-apple-darwin.tar.xz"
      sha256 "47da8747c010fe47e2a9d726968713b4c899c592ba8956d752f1b53cb41cb6a3"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/smartcrabai/gqlforge/releases/download/v0.1.6/gqlforge-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "61633235eaf334425e5a02138709565f0cd01f80cb8fd763cb6a8ca2d01f69af"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartcrabai/gqlforge/releases/download/v0.1.6/gqlforge-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b939f249606770f097c39889edabe1f7e928be342e1180c6ddc121ed656d92fa"
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
