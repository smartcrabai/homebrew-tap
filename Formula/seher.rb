class Seher < Formula
  desc "CLI tool to monitor Claude API rate limits and execute code after reset"
  homepage "https://github.com/takumi3488/seher"
  version "0.0.11"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/takumi3488/seher/releases/download/v0.0.11/sehercode-aarch64-apple-darwin.tar.xz"
      sha256 "e4c2323c44887367e73b70d68970e60ab1f4fff4e98c93dc93fbd9b92e8dea6b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/takumi3488/seher/releases/download/v0.0.11/sehercode-x86_64-apple-darwin.tar.xz"
      sha256 "62723e2378608fa042fcab3867e4bc6360a9d30e3abf5f464abee56c0104bbe7"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/takumi3488/seher/releases/download/v0.0.11/sehercode-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "abcc8020c912e888d4c8caa3236380a75fb1818989550bf521bbae3d5c754d9a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/takumi3488/seher/releases/download/v0.0.11/sehercode-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a96ed71da3f1ce19fb083be3dc0122f39b91f34c306b857fa8741d215ca8ed58"
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
