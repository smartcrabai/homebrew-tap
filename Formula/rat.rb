class Rat < Formula
  desc "Local command scheduling with explicit recovery of uncertain executions"
  homepage "https://github.com/smartcrabai/rat"
  version "0.1.1"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/smartcrabai/rat/releases/download/v0.1.1/rat-aarch64-apple-darwin.tar.xz"
    sha256 "d899f03222be026e77690dc322d7dd5c29537e10b26e39851753aeaa34c1accd"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/smartcrabai/rat/releases/download/v0.1.1/rat-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8fc4e153e2563db6b5bd39498305d9889966b35d279aa58424fa25ac5d6a3d86"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartcrabai/rat/releases/download/v0.1.1/rat-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7e4880862162a112c1dd964031f326f54e0918d79c5effd4b2f86543fdbf62b5"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
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
      bin.install "rat"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "rat"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "rat"
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
