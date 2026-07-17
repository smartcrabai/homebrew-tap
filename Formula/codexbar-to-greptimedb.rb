class CodexbarToGreptimedb < Formula
  desc "Export CodexBar usage snapshots to GreptimeDB"
  homepage "https://github.com/takumi3488/codexbar-to-greptimedb"
  version "0.1.3"
  license "Apache-2.0"
  depends_on :macos

  on_macos do
    depends_on macos: :sonoma
  end

  if Hardware::CPU.arm?
    url "https://github.com/takumi3488/codexbar-to-greptimedb/releases/download/v0.1.3/codexbar-to-greptimedb-0.1.3-macos-arm64.tar.gz"
    sha256 "5f451cbfea3f7655cb5f27a4feb41236403d290a9c738d8c60831a9538bafba7"
  elsif Hardware::CPU.intel?
    url "https://github.com/takumi3488/codexbar-to-greptimedb/releases/download/v0.1.3/codexbar-to-greptimedb-0.1.3-macos-x86_64.tar.gz"
    sha256 "cfa4534edaa869ea44760c1989cd49c97b34bab4da5061dd4e939bb5f0fdbf7a"
  end

  def install
    bin.install "codexbar-to-greptimedb"

    config = etc/"codexbar-to-greptimedb.env"
    unless config.exist?
      etc.mkpath
      config.write <<~EOS
        # Shell assignments exported to the Homebrew service.
        GREPTIMEDB_URL=http://localhost:4000
      EOS
    end
    config.chmod 0o600

    libexec.mkpath
    service_script = libexec/"codexbar-to-greptimedb-service"
    service_script.write <<~SH
      #!/bin/sh
      set -a
      . "#{config}"
      exec "#{opt_bin}/codexbar-to-greptimedb" --every-minute
    SH
    service_script.chmod 0755
  end

  service do
    run opt_libexec/"codexbar-to-greptimedb-service"
    environment_variables PATH: std_service_path_env
    log_path var/"log/codexbar-to-greptimedb.log"
    error_log_path var/"log/codexbar-to-greptimedb.log"
  end

  test do
    assert_match "--every-minute", shell_output("#{bin}/codexbar-to-greptimedb --help")
  end
end
