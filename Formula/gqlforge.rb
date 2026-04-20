class Gqlforge < Formula
  desc "A high-performance GraphQL runtime"
  homepage "https://gqlforge.pages.dev"
  version "0.1.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/smartcrabai/gqlforge/releases/download/v0.1.5/gqlforge-aarch64-apple-darwin.tar.xz"
      sha256 "2e1f1503f5dc10f03a8778f5fa4214ccccc69a9e17d7ea51b8793f93ce8c9c71"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartcrabai/gqlforge/releases/download/v0.1.5/gqlforge-x86_64-apple-darwin.tar.xz"
      sha256 "9fb554c362486ddf9f1f7e1bd6ddb0277bef4aeeb7e4dc8e7b235b372bd91aa1"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/smartcrabai/gqlforge/releases/download/v0.1.5/gqlforge-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "63b5755671227ace117dc075269083eb66a95005aedb018af0115fd003e6b4a1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartcrabai/gqlforge/releases/download/v0.1.5/gqlforge-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "91b2d67bf86f219766d1087c881ec0a68999d6118e49781f6d7c0a59749b076c"
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
    bin.install "gqlforge" if OS.mac? && Hardware::CPU.arm?
    bin.install "gqlforge" if OS.mac? && Hardware::CPU.intel?
    bin.install "gqlforge" if OS.linux? && Hardware::CPU.arm?
    bin.install "gqlforge" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
