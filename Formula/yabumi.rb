class Yabumi < Formula
  desc "A self-contained scripting language for Agent Skills"
  homepage "https://github.com/smartcrabai/yabumi"
  version "0.1.1"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/smartcrabai/yabumi/releases/download/v0.1.1/yabumi-aarch64-apple-darwin.tar.xz"
    sha256 "5e79bb9fb9b92a3baf420f008e11cf94efac9e3f13af076114d7a34f8db75a3c"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/smartcrabai/yabumi/releases/download/v0.1.1/yabumi-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d6b210c907f5936661727df91d192876152a63afb85dda3bf5497f59a110bee2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartcrabai/yabumi/releases/download/v0.1.1/yabumi-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c5165f2010692cd331edaf4fdbd2282cb8815f5c501b48e8de09f0023cfa38ff"
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
