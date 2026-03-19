class Seher < Formula
  desc "CLI tool to monitor Claude API rate limits and execute code after reset"
  homepage "https://github.com/smartcrabai/seher"
  version "0.0.24"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/smartcrabai/seher/releases/download/v0.0.24/sehercode-aarch64-apple-darwin.tar.xz"
      sha256 "d32cc5a482f6ba6297200db9f84f9486db73a7def31d9af485368bd36525d59f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartcrabai/seher/releases/download/v0.0.24/sehercode-x86_64-apple-darwin.tar.xz"
      sha256 "4c293ae9b92779852e14ef35b46eb457c7209d1d41af1da62e6d112401e2ca1d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/smartcrabai/seher/releases/download/v0.0.24/sehercode-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e1186dc166c9db60ddc3c4cf3da1357e5086aed6b92e33e5cf812b62030379ce"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartcrabai/seher/releases/download/v0.0.24/sehercode-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7f3bbf6a3525c5703cd44b80709156941b8c984cabd90cc6c5af4ddfaf4509d7"
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
