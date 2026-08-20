class Cruise < Formula
  desc "YAML-driven coding agent workflow orchestrator"
  homepage "https://github.com/smartcrabai/cruise"
  version "0.1.83"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/smartcrabai/cruise/releases/download/v0.1.83/cruise-aarch64-apple-darwin.tar.xz"
      sha256 "2803d92cb8cd0ca506d9c8144a3be397fdd7c053fef718964660bbf510322169"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartcrabai/cruise/releases/download/v0.1.83/cruise-x86_64-apple-darwin.tar.xz"
      sha256 "840d6ef167c200a1472105b2b1c552e9e6b525e8714ec9e7ab41c54984d0df9a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/smartcrabai/cruise/releases/download/v0.1.83/cruise-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a5b8a4bee8721c4a9fe536d4e3852f689ba0a14b370a4268ac8c015b61be5f87"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartcrabai/cruise/releases/download/v0.1.83/cruise-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0d9181c4099e99b29e39b7119a25642d2c35f6fab4aa21148ae11cdbc8607abb"
    end
  end
  license "MIT"

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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "cruise"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "cruise"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "cruise"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "cruise"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
