class Cruise < Formula
  desc "YAML-driven coding agent workflow orchestrator"
  homepage "https://github.com/smartcrabai/cruise"
  version "0.2.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/smartcrabai/cruise/releases/download/v0.2.4/cruise-aarch64-apple-darwin.tar.xz"
      sha256 "37fe4ceee27e811b5e2c1de3e838bd74b4bc0bf6324cd7fc70083195c190af14"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartcrabai/cruise/releases/download/v0.2.4/cruise-x86_64-apple-darwin.tar.xz"
      sha256 "a3ebca6072cbafff063cc1ebc631bcc2d8eb494ace1d394dd3a2d4a3f361fb40"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/smartcrabai/cruise/releases/download/v0.2.4/cruise-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1ce1ea1cee40fa2463ad68ecdb3b29c11f4930208728b5888f2c1f1bbe4edf2c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartcrabai/cruise/releases/download/v0.2.4/cruise-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "11fc16e5ef9b9f301428f2369b37e002b70925e4d6cedac90f616bbb121bf4a6"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
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
      bin.install "cruise"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "cruise"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "cruise"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "cruise"
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
