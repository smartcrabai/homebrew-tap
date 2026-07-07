class Sakoku < Formula
  desc "A fast CLI tool to detect non-ASCII bytes in source files"
  homepage "https://github.com/smartcrabai/sakoku"
  version "0.2.4"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/smartcrabai/sakoku/releases/download/v0.2.4/sakoku-aarch64-apple-darwin.tar.xz"
    sha256 "d9fe348484e71870ceb4a2beeb34366326386527782eee64b708c465c83ad0bc"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/smartcrabai/sakoku/releases/download/v0.2.4/sakoku-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "78dfdb53ede066c4da70bcfa6a37967aa62b9b30268b48bb30c40ff7b355f533"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartcrabai/sakoku/releases/download/v0.2.4/sakoku-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c78877afa7119568ce390487e95a86ec16e38b3b13291fd05c287ba4d3a6f0f9"
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
