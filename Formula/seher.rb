class Seher < Formula
  desc "Seher CLI: pick the highest-priority coding agent and run a plan/build prompt"
  homepage "https://github.com/smartcrabai/seher"
  version "0.0.43"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/smartcrabai/seher/releases/download/v0.0.43/seher-cli-aarch64-apple-darwin.tar.xz"
      sha256 "7861b31855b2143fb47c14a73773846ae9e357ef36689bc331b6a8123879f9f9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartcrabai/seher/releases/download/v0.0.43/seher-cli-x86_64-apple-darwin.tar.xz"
      sha256 "c8ef2f29cc2416b7c2ec13866df1a9395152825858152a148bfec01a30175ee0"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/smartcrabai/seher/releases/download/v0.0.43/seher-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6ac5fcf731f45a61a79b80646e541026e1e56688b35bbe7d8ee7f2d3015b6724"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartcrabai/seher/releases/download/v0.0.43/seher-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "44dd4b2c27ade21a7c6d9e8976be612dafe720679cb7a455858fe46e1c6fb328"
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
