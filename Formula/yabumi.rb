class Yabumi < Formula
  desc "A self-contained scripting language for Agent Skills"
  homepage "https://github.com/smartcrabai/yabumi"
  version "0.1.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/smartcrabai/yabumi/releases/download/v0.1.0/yabumi-aarch64-apple-darwin.tar.xz"
    sha256 "2f13be595dd031e62a2b1b2800b47600b50ce41370be34c242fbe4eb2fb12cad"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/smartcrabai/yabumi/releases/download/v0.1.0/yabumi-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e3b1cdab549164557ad52ad0b0430d53f5a1d1c54661b97f60f256c18cb387b9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartcrabai/yabumi/releases/download/v0.1.0/yabumi-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a1f60e1e21929ffacd77dc4da9b2908218b36ad8e4b75abfb0dc1e9cfc1e8182"
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
      bin.install "ybm", "yabumi"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "ybm", "yabumi"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "ybm", "yabumi"
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
