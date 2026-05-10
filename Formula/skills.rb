class Skills < Formula
  desc "CLI for installing and managing agent skills (SKILL.md collections) across local development tooling"
  homepage "https://github.com/smartcrabai/skills"
  version "0.1.4"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/smartcrabai/skills/releases/download/v0.1.4/skills-aarch64-apple-darwin.tar.xz"
    sha256 "e19064b8df35b77c63855e6b16e067c8f400c084759aa59c80bb8fbd1df4d441"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/smartcrabai/skills/releases/download/v0.1.4/skills-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0f9030565beea783d9bd01a3d9959083f5802f250388decfb1b25c328e31535b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartcrabai/skills/releases/download/v0.1.4/skills-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f964bfe715e217b876dd8046855f949693aa74cb72b4745ffb69bd391a54ad03"
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
