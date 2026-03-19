class Sakoku < Formula
  desc "A fast CLI tool to detect non-ASCII bytes in source files"
  homepage "https://github.com/smartcrabai/sakoku"
  version "0.1.3"
  if OS.mac? && Hardware::CPU.arm?
      url "https://github.com/smartcrabai/sakoku/releases/download/v0.1.3/sakoku-aarch64-apple-darwin.tar.xz"
      sha256 "22edc0582bc20c9ad0a1fd68d8a5d7e98b7784272dd4d0447f032690f761134b"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/smartcrabai/sakoku/releases/download/v0.1.3/sakoku-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "06c8a12eb8739777d75231404ab31af2973e3d6afd5446e9d688918efb0b8cfe"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartcrabai/sakoku/releases/download/v0.1.3/sakoku-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "88d272cfdb207867147b8cf5a37926147ae7d0cfe861b93da99547be4c48bf0b"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-pc-windows-gnu":    {},
    "aarch64-unknown-linux-gnu": {},
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
    bin.install "sakoku" if OS.mac? && Hardware::CPU.arm?
    bin.install "sakoku" if OS.linux? && Hardware::CPU.arm?
    bin.install "sakoku" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
