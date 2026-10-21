class Cruise < Formula
  desc "YAML-driven coding agent workflow orchestrator"
  homepage "https://github.com/smartcrabai/cruise"
  version "0.2.17"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/smartcrabai/cruise/releases/download/v0.2.17/cruise-aarch64-apple-darwin.tar.xz"
      sha256 "0f9abc03ff3a13a212ae1ade949e6cf98a4e16c24e5fb7f41a0a98abaab1ad49"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartcrabai/cruise/releases/download/v0.2.17/cruise-x86_64-apple-darwin.tar.xz"
      sha256 "12edc6771e76e26af6ce281b67b52794cec1b841d0a9705b50beedfc4dc1a35a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/smartcrabai/cruise/releases/download/v0.2.17/cruise-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3b63750f4051b29cd183b461b82990bd9e99062a0af347d0c3d38e1375eb1cea"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartcrabai/cruise/releases/download/v0.2.17/cruise-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1a40bef90d705ba0cbff768397a82dfce25b95c5c70d506621c293b5a6415dd5"
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
