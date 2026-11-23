class Cruise < Formula
  desc "YAML-driven coding agent workflow orchestrator"
  homepage "https://github.com/smartcrabai/cruise"
  version "0.3.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/smartcrabai/cruise/releases/download/v0.3.3/cruise-aarch64-apple-darwin.tar.xz"
      sha256 "e3e291c5efe5eaadc83871cff5aa92f1e3fb958c0ba90d354c1200c7285691f3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartcrabai/cruise/releases/download/v0.3.3/cruise-x86_64-apple-darwin.tar.xz"
      sha256 "ca4f8e93220dce3f48d7247afb7d639f2f7f0fa29f243638e817c4c38bd78608"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/smartcrabai/cruise/releases/download/v0.3.3/cruise-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2f9be9ae2746de24b131bd46d68c0cc846f09cab2b76cd1d60e89d1bc46bdc77"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartcrabai/cruise/releases/download/v0.3.3/cruise-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "14be7506483a8f629c96a8bc07e6fcf1f5f8595cd178037b33985dc5b35f0b36"
    end
  end
  license "Apache-2.0"

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
