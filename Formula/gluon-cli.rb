class GluonCli < Formula
  desc "CLI for the gluon framework"
  homepage "https://github.com/smartcrabai/gluon"
  version "0.1.4"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/smartcrabai/gluon/releases/download/v0.1.4/gluon-cli-aarch64-apple-darwin.tar.xz"
    sha256 "53454a6da8b56ebe29c519b3aac6caff3ca5f876bdd48aacdb6d3442ca73ec51"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/smartcrabai/gluon/releases/download/v0.1.4/gluon-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "88822f229a01e1e90a87b8d39c175f117ca7c51caae5ec0fb2f4e0fbaaf99b64"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartcrabai/gluon/releases/download/v0.1.4/gluon-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "acb9cb6162ef2df4d671f4eae80aa498c9df13c0f98c4bd377366d1b52a7f94b"
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
