class Cruise < Formula
  desc "YAML-driven coding agent workflow orchestrator"
  homepage "https://github.com/smartcrabai/cruise"
  version "0.2.15"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/smartcrabai/cruise/releases/download/v0.2.15/cruise-aarch64-apple-darwin.tar.xz"
      sha256 "6583ef263a7f4abe75b7ea463073585f507a86c3581a5a4131bf741db44028c1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartcrabai/cruise/releases/download/v0.2.15/cruise-x86_64-apple-darwin.tar.xz"
      sha256 "60e543fff7d012dc673d60718e8b033d3b9351b10e16db577ff5d47fc03e490f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/smartcrabai/cruise/releases/download/v0.2.15/cruise-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d484e880331637167740d2029d9ec6c9618b376a0e890338a74f93e697619d79"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartcrabai/cruise/releases/download/v0.2.15/cruise-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a18dcc924c95c12c1a777f5f74fa6bdf262be494bd60a2ea4c197615b012e41a"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
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
