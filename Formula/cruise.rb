class Cruise < Formula
  desc "YAML-driven coding agent workflow orchestrator"
  homepage "https://github.com/smartcrabai/cruise"
  version "0.2.16"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/smartcrabai/cruise/releases/download/v0.2.16/cruise-aarch64-apple-darwin.tar.xz"
      sha256 "cfe1b8c5661d51b577e1b507f836b83bf7ac6250c96aabb5ea21933bc0e0f585"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartcrabai/cruise/releases/download/v0.2.16/cruise-x86_64-apple-darwin.tar.xz"
      sha256 "c09148cb5b675544503c408dafd2a28d31bc1d5668ba11e3d1a8974e1b86135b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/smartcrabai/cruise/releases/download/v0.2.16/cruise-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "55cb4bcea6abf7e8875a585eeded0f9bfe04e14ad09467ff25f5437ca56052c6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartcrabai/cruise/releases/download/v0.2.16/cruise-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "07a79f7f3e6c9dd3ff0c2fc4ac1bb56400ce8136cea61963e8ccd0773903680a"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
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
      bin.install "cruise", "cruise-runtime"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "cruise", "cruise-runtime"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "cruise", "cruise-runtime"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "cruise", "cruise-runtime"
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
