class Cruise < Formula
  desc "YAML-driven coding agent workflow orchestrator"
  homepage "https://github.com/smartcrabai/cruise"
  version "0.1.81"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/smartcrabai/cruise/releases/download/v0.1.81/cruise-aarch64-apple-darwin.tar.xz"
      sha256 "2630a843a6ca43b2c3bbbd99450014fd6da99748744b35447a17e4f2edf884b0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartcrabai/cruise/releases/download/v0.1.81/cruise-x86_64-apple-darwin.tar.xz"
      sha256 "32d494e7489c8b6b35beccdefc6aed7d3c3b2a2303611932700dfe0a1ce856ce"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/smartcrabai/cruise/releases/download/v0.1.81/cruise-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "83c78c090a619f8a20660fe5240c7d62222bee7f298064c582fbdcb2c12a9a6b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartcrabai/cruise/releases/download/v0.1.81/cruise-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "46ad69e736487410b9d803a43ac7cb1781874704c8aac55f4ca38ed14dbd7e0a"
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
