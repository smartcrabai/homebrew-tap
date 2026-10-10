class Potter < Formula
  desc "Headless, AI-friendly 3D creation CLI with Blender-compatible modeling, evaluation, and .blend exchange"
  homepage "https://github.com/smartcrabai/potter"
  version "0.1.1"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/smartcrabai/potter/releases/download/v0.1.1/potter-aarch64-apple-darwin.tar.xz"
    sha256 "aa463c985211506ee3fd809cd0b4f7328b4b943e47381b76fcad998017a73935"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/smartcrabai/potter/releases/download/v0.1.1/potter-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4ebce78ca7d9e6e1622ea6f672b9fd042a65910cf5e7166f097166b6644be453"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartcrabai/potter/releases/download/v0.1.1/potter-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "085984adfcb9cca21cfbbda0211d68a2d8bb60dc51adb409e22ce97be7512dd6"
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
