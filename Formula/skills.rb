class Skills < Formula
  desc "CLI for installing and managing agent skills (SKILL.md collections) across local development tooling"
  homepage "https://github.com/smartcrabai/skills"
  version "0.1.6"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/smartcrabai/skills/releases/download/v0.1.6/skills-aarch64-apple-darwin.tar.xz"
    sha256 "04bead168dd6e3727a7b934e61db03a1e8a3a7c61269e0c8564d0a4b2138a911"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/smartcrabai/skills/releases/download/v0.1.6/skills-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3efc03280b5ad2b374bbd1cc79e2f085e9c5f1c816b4787f1ec87d7d907c87b2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartcrabai/skills/releases/download/v0.1.6/skills-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c22a499775c25b7fc41563568c6356e8bb86069393f800ae945f0b642b6b36b1"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
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
    bin.install "skills" if OS.mac? && Hardware::CPU.arm?
    bin.install "skills" if OS.linux? && Hardware::CPU.arm?
    bin.install "skills" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
