class Yabumi < Formula
  desc "A self-contained scripting language for Agent Skills"
  homepage "https://github.com/smartcrabai/yabumi"
  version "0.1.3"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/smartcrabai/yabumi/releases/download/v0.1.3/yabumi-aarch64-apple-darwin.tar.xz"
    sha256 "1f8fdea465768db9e2c7115bd579bbcf29e71d6a493464a47d970c7c11cd15b4"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/smartcrabai/yabumi/releases/download/v0.1.3/yabumi-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7b961d3ce6ab9d36761c80f3b8faef054deacb4ae8adf44723f1fcfdf82958e3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartcrabai/yabumi/releases/download/v0.1.3/yabumi-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "fb4c139049de85e861443ed4de08adc0dbfb00e3632701b7413c90c8a599e970"
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
