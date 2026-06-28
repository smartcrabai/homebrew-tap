class Seher < Formula
  desc "Seher CLI: pick the highest-priority coding agent and run a plan/build prompt"
  homepage "https://github.com/smartcrabai/seher"
  version "0.0.49"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/smartcrabai/seher/releases/download/v0.0.49/seher-cli-aarch64-apple-darwin.tar.xz"
      sha256 "b47c52af880756b61be33fa0a07a6e8e3d287dedc962e257665b4f7dd17bf406"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartcrabai/seher/releases/download/v0.0.49/seher-cli-x86_64-apple-darwin.tar.xz"
      sha256 "318b60b224a83073a4b00fe33aa945acbc22a0f0b5e90528a9305cfe1d1f2d6f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/smartcrabai/seher/releases/download/v0.0.49/seher-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d9a645b21dea7fe13483a300eba3a57fd443f3b25698e7dcea4dfc08babbd472"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartcrabai/seher/releases/download/v0.0.49/seher-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "982620d623f30f562ce1548cb87257e439973aef7d05f9eed77fe447e0da649d"
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
