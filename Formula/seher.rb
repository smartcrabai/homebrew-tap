class Seher < Formula
  desc "Seher CLI: pick the highest-priority coding agent and run a plan/build prompt"
  homepage "https://github.com/smartcrabai/seher"
  version "0.0.50"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/smartcrabai/seher/releases/download/v0.0.50/seher-cli-aarch64-apple-darwin.tar.xz"
      sha256 "d179cc67769bd40136200ee8d1a8a619338900f164a25e9fc18c5f8bf6b36c2d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartcrabai/seher/releases/download/v0.0.50/seher-cli-x86_64-apple-darwin.tar.xz"
      sha256 "983d77e501e1f4939661d9b45720e880b62a683bb28fea0daf21979fc645749a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/smartcrabai/seher/releases/download/v0.0.50/seher-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2e880f8930df07bb6ce7b9fa4b9ad06ae313ea70a038681ad2d7d6ee0febd09b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartcrabai/seher/releases/download/v0.0.50/seher-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6c290ea2d44851776fb559da4ce210e13bab30704b18399102eef04d7b20d360"
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
