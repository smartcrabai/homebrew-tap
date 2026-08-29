class Yabumi < Formula
  desc "A self-contained scripting language for Agent Skills"
  homepage "https://github.com/smartcrabai/yabumi"
  version "0.1.2"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/smartcrabai/yabumi/releases/download/v0.1.2/yabumi-aarch64-apple-darwin.tar.xz"
    sha256 "110f0e77a8cb006cd9d984f51eb4b59c10143ec6a96e8186012b522c0fc773e8"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/smartcrabai/yabumi/releases/download/v0.1.2/yabumi-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "9ad08ae15a59380abb427c09a6c4476065b704b6cb2e9e2b349f1c90521b757e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartcrabai/yabumi/releases/download/v0.1.2/yabumi-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ab2d052f7d140ea07511373d92911664555a439bd9788ca39b5c73c42edf52f8"
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
