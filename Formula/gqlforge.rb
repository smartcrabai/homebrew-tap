class Gqlforge < Formula
  desc "A high-performance GraphQL runtime"
  homepage "https://gqlforge.pages.dev"
  version "0.1.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/smartcrabai/gqlforge/releases/download/v0.1.8/gqlforge-aarch64-apple-darwin.tar.xz"
      sha256 "a9a0a5fc86e5cea5fa34d5ff6d9619106d59054aea024a72094142c4bfae684f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartcrabai/gqlforge/releases/download/v0.1.8/gqlforge-x86_64-apple-darwin.tar.xz"
      sha256 "3210951202782d6e43c7ce31ecc467831e6e67c75f95c6717cac370fe14be0c7"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/smartcrabai/gqlforge/releases/download/v0.1.8/gqlforge-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8108a607635b09ba4681be0aac74e45d2766db9cf5e0f37f08debc3a74bb9112"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartcrabai/gqlforge/releases/download/v0.1.8/gqlforge-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ef10c5785257cb060552e80d57b69a4ebf1c78efc7c4f3bfb2aae6c9fca49a81"
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
