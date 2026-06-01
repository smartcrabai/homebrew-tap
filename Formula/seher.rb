class Seher < Formula
  desc "Seher CLI: pick the highest-priority coding agent and run a plan/build prompt"
  homepage "https://github.com/smartcrabai/seher"
  version "0.0.35"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/smartcrabai/seher/releases/download/v0.0.35/seher-cli-aarch64-apple-darwin.tar.xz"
      sha256 "d392fc2418de6b29c0ee9d42546a9a07b29e34e772229b12f540b4c97f1fff83"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartcrabai/seher/releases/download/v0.0.35/seher-cli-x86_64-apple-darwin.tar.xz"
      sha256 "0e059a992a7b0379c1ec1ffec82e15987e6d2aef306cd1feee035ee7298f475c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/smartcrabai/seher/releases/download/v0.0.35/seher-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "409db1503eefeca497f7d0592ea4f7d2cc6a353c2b14d6849d5990bbc4b043b9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartcrabai/seher/releases/download/v0.0.35/seher-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "56aeec070e744c3530545aa08365c92c2bd4cdada32add689473dc2fd81a8f10"
    end
  end
  license "Apache-2.0"

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
    bin.install "seher" if OS.mac? && Hardware::CPU.arm?
    bin.install "seher" if OS.mac? && Hardware::CPU.intel?
    bin.install "seher" if OS.linux? && Hardware::CPU.arm?
    bin.install "seher" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
