class Cruise < Formula
  desc "YAML-driven coding agent workflow orchestrator"
  homepage "https://github.com/smartcrabai/cruise"
  version "0.1.82"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/smartcrabai/cruise/releases/download/v0.1.82/cruise-aarch64-apple-darwin.tar.xz"
      sha256 "5b5a421ed420669dcebde3497776e5dac258ce276a66017f72230ecba87b498e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartcrabai/cruise/releases/download/v0.1.82/cruise-x86_64-apple-darwin.tar.xz"
      sha256 "d0946a8e2f7f851e032fe95ada1708692813b1b8a80ad09a45ed1992242659c1"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/smartcrabai/cruise/releases/download/v0.1.82/cruise-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "452c0b68a0633e12a1379d46e003b1c5ad51314ccbf60e05b76bc445d85ceb36"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartcrabai/cruise/releases/download/v0.1.82/cruise-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "51158475d1a5590f5043f6e51db718ffae8e86767dc782467e9d2141b7efb828"
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
