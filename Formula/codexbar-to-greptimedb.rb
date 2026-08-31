class CodexbarToGreptimedb < Formula
  desc "Export CodexBar usage snapshots to GreptimeDB"
  homepage "https://github.com/smartcrabai/codexbar-to-greptimedb"
  version "0.1.11"
  license "Apache-2.0"
  depends_on :macos

  on_macos do
    depends_on macos: :sonoma
  end

  if Hardware::CPU.arm?
    url "https://github.com/smartcrabai/codexbar-to-greptimedb/releases/download/v0.1.11/codexbar-to-greptimedb-0.1.11-macos-arm64.tar.gz"
    sha256 "10544bb7a055d978a9aa7090bab9c60b1b424bc6f5f39e5a2d3295c6dd22bc86"
  elsif Hardware::CPU.intel?
    url "https://github.com/smartcrabai/codexbar-to-greptimedb/releases/download/v0.1.11/codexbar-to-greptimedb-0.1.11-macos-x86_64.tar.gz"
    sha256 "2f74f219c58942811f88eef8d08ecc1d4f337f7884e3e014381332af27ed2c34"
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
