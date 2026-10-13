class Potter < Formula
  desc "Headless, AI-friendly 3D creation CLI with Blender-compatible modeling, evaluation, and .blend exchange"
  homepage "https://github.com/smartcrabai/potter"
  version "0.2.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/smartcrabai/potter/releases/download/v0.2.0/potter-aarch64-apple-darwin.tar.xz"
    sha256 "c4589bab74b7a4b52be75660d870ad52b8433047769e13597934f895dfb376d3"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/smartcrabai/potter/releases/download/v0.2.0/potter-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c82622a85353a70105b9f0b8b6c5581b1c154a82b54083a8bf7faca59549efbf"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartcrabai/potter/releases/download/v0.2.0/potter-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e6e259e0d91bb2ac4682733ae9a4b612b0d25089c389fa5ead3733cd73ef47fc"
    end
  end
  license "GPL-3.0-or-later"

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
      bin.install "pot"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "pot"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "pot"
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
