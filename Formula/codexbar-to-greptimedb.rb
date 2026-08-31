class CodexbarToGreptimedb < Formula
  desc "Export CodexBar usage snapshots to GreptimeDB"
  homepage "https://github.com/smartcrabai/codexbar-to-greptimedb"
  version "0.1.9"
  license "Apache-2.0"
  depends_on :macos

  on_macos do
    depends_on macos: :sonoma
  end

  if Hardware::CPU.arm?
    url "https://github.com/smartcrabai/codexbar-to-greptimedb/releases/download/v0.1.9/codexbar-to-greptimedb-0.1.9-macos-arm64.tar.gz"
    sha256 "773b98af1ef69babafa7f195c351b72a7d5d7d95ca01d7c70cb1ee6b3c9af9bd"
  elsif Hardware::CPU.intel?
    url "https://github.com/smartcrabai/codexbar-to-greptimedb/releases/download/v0.1.9/codexbar-to-greptimedb-0.1.9-macos-x86_64.tar.gz"
    sha256 "77184cf7e8ea5b962919e5a80475691f60121e681600f94a1db2f42a116e31a6"
  end

  def install
    prefix.install "CodexBarToGreptimeDB.app"
    bin.write_exec_script prefix/"CodexBarToGreptimeDB.app/Contents/MacOS/codexbar-to-greptimedb"

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
      exec "#{opt_prefix}/CodexBarToGreptimeDB.app/Contents/MacOS/codexbar-to-greptimedb" --every-minute
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
