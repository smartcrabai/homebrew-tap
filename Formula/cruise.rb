class Cruise < Formula
  desc "YAML-driven coding agent workflow orchestrator"
  homepage "https://github.com/smartcrabai/cruise"
  version "0.2.19"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/smartcrabai/cruise/releases/download/v0.2.19/cruise-aarch64-apple-darwin.tar.xz"
      sha256 "d05d36db626d05f9ca629c970dae01460e234c35b37cfb4f4ba1011f894fb18c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartcrabai/cruise/releases/download/v0.2.19/cruise-x86_64-apple-darwin.tar.xz"
      sha256 "080eb72fae0091ad0ec9dcbf6e6bcb122ab61bc554d79168e5edb5f94f0fd648"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/smartcrabai/cruise/releases/download/v0.2.19/cruise-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "fa1205003c1efc5772dec75996bfcf1267c25dfc4f64d6c1af87143841c0e172"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartcrabai/cruise/releases/download/v0.2.19/cruise-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "490cea91bf029c1c76952fa71eef073c649a4227bc57a3d060aaa4da9785c3c1"
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
      bin.install "cruise", "cruise-runtime"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "cruise", "cruise-runtime"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "cruise", "cruise-runtime"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "cruise", "cruise-runtime"
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
