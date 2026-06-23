class Cruise < Formula
  desc "YAML-driven coding agent workflow orchestrator"
  homepage "https://github.com/smartcrabai/cruise"
  version "0.1.60"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/smartcrabai/cruise/releases/download/v0.1.60/cruise-aarch64-apple-darwin.tar.xz"
      sha256 "dde81680e325496bce4fa23bdfe92bec038d4b41a72f65421f5a806abb7d7bde"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartcrabai/cruise/releases/download/v0.1.60/cruise-x86_64-apple-darwin.tar.xz"
      sha256 "0e8b3984252b1c9a2f998f5806042ebcd8bb2446ba8351f008aebc47bc37dacc"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/smartcrabai/cruise/releases/download/v0.1.60/cruise-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f1494112304d8d4e1e0eccf1d519cef8dd55a7514907829faf2a045597f10949"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartcrabai/cruise/releases/download/v0.1.60/cruise-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "91ae381d1b7bd434cab67d66e9529e59ab8091a395e4bed07359772add18e137"
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
