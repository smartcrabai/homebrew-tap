class Potter < Formula
  desc "Headless, AI-friendly 3D creation CLI with Blender-compatible modeling, evaluation, and .blend exchange"
  homepage "https://github.com/smartcrabai/potter"
  version "0.1.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/smartcrabai/potter/releases/download/v0.1.0/potter-aarch64-apple-darwin.tar.xz"
    sha256 "6b9697cd45c2a5e83382022f854a649936d5f2a92762450913e4f4dff8f60d12"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/smartcrabai/potter/releases/download/v0.1.0/potter-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "724d785c898349d8d9690a57cadb2aa4a9e6d6958bb98179a8f0d2da8ca2e249"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartcrabai/potter/releases/download/v0.1.0/potter-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "948821c4872f43e2a2472ebf58aa8fa98823e74c7586b5e2a189fe6ea58e7ff3"
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
