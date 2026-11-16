class Potter < Formula
  desc "Headless, AI-friendly 3D creation CLI with Blender-compatible modeling, evaluation, and .blend exchange"
  homepage "https://github.com/smartcrabai/potter"
  version "0.3.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/smartcrabai/potter/releases/download/v0.3.0/potter-aarch64-apple-darwin.tar.xz"
    sha256 "5ced33b90916653f6334aa1f62b61c8eb9e905572fbef678ef06ee35d1d1e980"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/smartcrabai/potter/releases/download/v0.3.0/potter-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "61a4c4469b179b5196a873c36e755c57fa93dc4d2e73863b188e267015baaa16"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartcrabai/potter/releases/download/v0.3.0/potter-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8835493ce5fd45aa1fab0e8b355d4468109293da6e5132b95daf9bcd2eba8244"
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
