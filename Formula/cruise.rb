class Cruise < Formula
  desc "YAML-driven coding agent workflow orchestrator"
  homepage "https://github.com/smartcrabai/cruise"
  version "0.1.65"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/smartcrabai/cruise/releases/download/v0.1.65/cruise-aarch64-apple-darwin.tar.xz"
      sha256 "3e2bf3272e6ff2a4378fc1ddb99b500dd3f9030e9e566dbc4c0b60e9c9067093"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartcrabai/cruise/releases/download/v0.1.65/cruise-x86_64-apple-darwin.tar.xz"
      sha256 "09e6b77a3992df70361a572c0a19cbf3acf26d17c65560e8d860f72c9edd9b17"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/smartcrabai/cruise/releases/download/v0.1.65/cruise-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a0b7b18186fadc67c77b79118a57ea90e77799b22600003b83c1b7bfc938c9be"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartcrabai/cruise/releases/download/v0.1.65/cruise-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7ef35cea219019c3ddbf219b0794248d893c116cc5886fb63f30bf5f0f333af3"
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
    bin.install "cruise" if OS.mac? && Hardware::CPU.arm?
    bin.install "cruise" if OS.mac? && Hardware::CPU.intel?
    bin.install "cruise" if OS.linux? && Hardware::CPU.arm?
    bin.install "cruise" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
