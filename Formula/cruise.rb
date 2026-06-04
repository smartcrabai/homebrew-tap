class Cruise < Formula
  desc "YAML-driven coding agent workflow orchestrator"
  homepage "https://github.com/smartcrabai/cruise"
  version "0.1.44"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/smartcrabai/cruise/releases/download/v0.1.44/cruise-aarch64-apple-darwin.tar.xz"
      sha256 "0c0b7fc480e28691eef19bfee276558eeeeac39479900b4f4415f17983fdfbd2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartcrabai/cruise/releases/download/v0.1.44/cruise-x86_64-apple-darwin.tar.xz"
      sha256 "49c7ca6815cfdabbc2894f8a39f20d5c61f935350922693afbf43babd7e41310"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/smartcrabai/cruise/releases/download/v0.1.44/cruise-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "07b947789a0455994e81d3550de177017d2f3113e2367b86a84d5ff72609809f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartcrabai/cruise/releases/download/v0.1.44/cruise-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "07a868f26f89bb747ddc23bea35e3a86c1d531e683c8890d6e343224c3f95044"
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
