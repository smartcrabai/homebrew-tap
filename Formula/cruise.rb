class Cruise < Formula
  desc "YAML-driven coding agent workflow orchestrator"
  homepage "https://github.com/smartcrabai/cruise"
  version "0.2.17"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/smartcrabai/cruise/releases/download/v0.2.17/cruise-aarch64-apple-darwin.tar.xz"
      sha256 "8a48ad24df53e0f75e72e713a114abc1169dd7db9d341765cfb6785bc0364808"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartcrabai/cruise/releases/download/v0.2.17/cruise-x86_64-apple-darwin.tar.xz"
      sha256 "d7634f993a1d979fff35851ac06d10bec8a4dd0292f538a12a22764aba94d9e5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/smartcrabai/cruise/releases/download/v0.2.17/cruise-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c595d09a3e9ec0d3309d7701f93954e5726fdb063205988c4404ab828e8b1708"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartcrabai/cruise/releases/download/v0.2.17/cruise-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5cdd18952503d7fc0e71f79167be51710896e673b99db5c866ab6f4e7b1532d2"
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
