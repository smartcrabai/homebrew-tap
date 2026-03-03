class Seher < Formula
  desc "CLI tool to monitor Claude API rate limits and execute code after reset"
  homepage "https://github.com/takumi3488/seher"
  version "0.0.13"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/takumi3488/seher/releases/download/v0.0.13/sehercode-aarch64-apple-darwin.tar.xz"
      sha256 "0c493f4859fca31d69f0e100f15b67b9ba8f484d6b42494cfcc30f05a92e96b5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/takumi3488/seher/releases/download/v0.0.13/sehercode-x86_64-apple-darwin.tar.xz"
      sha256 "48b01277f73494d26b3780b8755e12ef40a559c2ef8bd0cdbe3a474c514412e2"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/takumi3488/seher/releases/download/v0.0.13/sehercode-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7524fe209eda8b62b66b9b3352676f6cd68fc46cea1f52c163baca470aa486f8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/takumi3488/seher/releases/download/v0.0.13/sehercode-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e2d9d5de2b7c3fcdb0cbafb3def9d062a55fcb0d32df92ce39991318c0fc0845"
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
