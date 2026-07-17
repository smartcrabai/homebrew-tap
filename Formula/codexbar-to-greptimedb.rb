class CodexbarToGreptimedb < Formula
  desc "Export CodexBar usage snapshots to GreptimeDB"
  homepage "https://github.com/takumi3488/codexbar-to-greptimedb"
  version "0.1.4"
  license "Apache-2.0"
  depends_on :macos

  on_macos do
    depends_on macos: :sonoma
  end

  if Hardware::CPU.arm?
    url "https://github.com/takumi3488/codexbar-to-greptimedb/releases/download/v0.1.4/codexbar-to-greptimedb-0.1.4-macos-arm64.tar.gz"
    sha256 "4a4d3a7c272628bb0a60b4be7d5ff3fb40721d0617309cda55b4c03174bd55df"
  elsif Hardware::CPU.intel?
    url "https://github.com/takumi3488/codexbar-to-greptimedb/releases/download/v0.1.4/codexbar-to-greptimedb-0.1.4-macos-x86_64.tar.gz"
    sha256 "b6f67ee6132759104483718f14bf598e2b1e7069fec8cdaccac661dcd6864fc3"
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
