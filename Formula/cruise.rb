class Cruise < Formula
  desc "YAML-driven coding agent workflow orchestrator"
  homepage "https://github.com/smartcrabai/cruise"
  version "0.1.24"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/smartcrabai/cruise/releases/download/v0.1.24/cruise-aarch64-apple-darwin.tar.xz"
      sha256 "bf20d6e290986a6039a7c721aacf03aadd492aff3a1aa701f09563238e19c16d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartcrabai/cruise/releases/download/v0.1.24/cruise-x86_64-apple-darwin.tar.xz"
      sha256 "55b7ae8f769f65c591bb0667d52e6ea71e79520fa32d0951057c4771b3082cde"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/smartcrabai/cruise/releases/download/v0.1.24/cruise-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2347eaa41c4b7e5c8c7a044204664a8b138d601744fd5b60554588ceccaaecce"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartcrabai/cruise/releases/download/v0.1.24/cruise-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "538a50e866c66384e6efd113ad6c88fc76fcfd4754fae8a0daca6d67e73f6a35"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-pc-windows-gnu":    {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
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
