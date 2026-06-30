class Seher < Formula
  desc "Seher CLI: pick the highest-priority coding agent and run a plan/build prompt"
  homepage "https://github.com/smartcrabai/seher"
  version "0.0.51"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/smartcrabai/seher/releases/download/v0.0.51/seher-cli-aarch64-apple-darwin.tar.xz"
      sha256 "57aea9292fd0d6f6a5693403e0ca68442373c1b53af8ed818b44b2faf80272b3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartcrabai/seher/releases/download/v0.0.51/seher-cli-x86_64-apple-darwin.tar.xz"
      sha256 "8e80229bde97e64543d3f03b905de65fa9251450a0895ff4abfd710c45e05d0e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/smartcrabai/seher/releases/download/v0.0.51/seher-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6950265f9d74f6a7306220b9aadddfb5a4a542f234e7fc954a850070e867c7d9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartcrabai/seher/releases/download/v0.0.51/seher-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "04c22f3347be000a6130bc965d24a0d8b03f52e088be2607547831f53f2a19b3"
    end
  end
  license "Apache-2.0"

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
    bin.install "seher" if OS.mac? && Hardware::CPU.arm?
    bin.install "seher" if OS.mac? && Hardware::CPU.intel?
    bin.install "seher" if OS.linux? && Hardware::CPU.arm?
    bin.install "seher" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
