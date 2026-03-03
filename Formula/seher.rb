class Seher < Formula
  desc "CLI tool to monitor Claude API rate limits and execute code after reset"
  homepage "https://github.com/smartcrabai/seher"
  version "0.0.14"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/smartcrabai/seher/releases/download/v0.0.14/sehercode-aarch64-apple-darwin.tar.xz"
      sha256 "6c7aefbb34365ec56c4c13eb17918eaa4418b9da26aa7bd1d4b581f285462614"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartcrabai/seher/releases/download/v0.0.14/sehercode-x86_64-apple-darwin.tar.xz"
      sha256 "c16480d4c47df0ff2e3bbb42d17d0cd91a443f81d10228d683f6a40dd04e7d66"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/smartcrabai/seher/releases/download/v0.0.14/sehercode-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "9a49e97321f6d632d8701c781194b59ec7a9a583b0a50a0b1c0c04a8f3196c29"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartcrabai/seher/releases/download/v0.0.14/sehercode-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "aed83a15d9d79d57d3525d630bec479fc1231c04f4264eef8007c7c086556aca"
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
    bin.install "seher" if OS.mac? && Hardware::CPU.arm?
    bin.install "seher" if OS.mac? && Hardware::CPU.intel?
    bin.install "seher" if OS.linux? && Hardware::CPU.arm?
    bin.install "seher" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
