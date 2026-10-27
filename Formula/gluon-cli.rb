class GluonCli < Formula
  desc "CLI for the gluon framework"
  homepage "https://github.com/smartcrabai/gluon"
  version "0.1.2"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/smartcrabai/gluon/releases/download/v0.1.2/gluon-cli-aarch64-apple-darwin.tar.xz"
    sha256 "a99ee85f3dcf876a642a7ee8b49fc3d9dad8f0c75a8f90daccc5fa547badd74a"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/smartcrabai/gluon/releases/download/v0.1.2/gluon-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "425f4ed7d0c78b3e0e4a4cbe8de212d72ccbe4d8ae01f82b8a24c3201766e938"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartcrabai/gluon/releases/download/v0.1.2/gluon-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "cb91af29063eb5e0ce3824a1188d705213367ae9d43e5bbe30ef300b1475cdd6"
    end
  end
  license "MIT"

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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "gluon"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "gluon"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "gluon"
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
