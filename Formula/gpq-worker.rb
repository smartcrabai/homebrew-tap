class GpqWorker < Formula
  desc "Tenant-owned GPU worker for GPU Generation Queue"
  homepage "https://github.com/smartcrabai/gpq"
  version "0.1.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/smartcrabai/gpq/releases/download/v0.1.0/gpq-worker-aarch64-apple-darwin.tar.xz"
    sha256 "c2b81b128f241035678121df5d316103411f618329aa1b9f08ebb9cbd872913d"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/smartcrabai/gpq/releases/download/v0.1.0/gpq-worker-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "cb3e8636d823f8e0dca1a184b05d0fa9b55f8980542ff7881356612a7616e067"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartcrabai/gpq/releases/download/v0.1.0/gpq-worker-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4200ee11ac4f4031efc6f5b65341d73d74d12ba27f938404ee2e5aaf0288ee62"
    end
  end
  license "Apache-2.0"

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
      bin.install "gpq-worker"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "gpq-worker"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "gpq-worker"
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
