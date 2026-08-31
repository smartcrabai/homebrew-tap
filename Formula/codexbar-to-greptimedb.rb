class CodexbarToGreptimedb < Formula
  desc "Export CodexBar usage snapshots to GreptimeDB"
  homepage "https://github.com/smartcrabai/codexbar-to-greptimedb"
  version "0.1.8"
  license "Apache-2.0"
  depends_on :macos

  on_macos do
    depends_on macos: :sonoma
  end

  if Hardware::CPU.arm?
    url "https://github.com/smartcrabai/codexbar-to-greptimedb/releases/download/v0.1.8/codexbar-to-greptimedb-0.1.8-macos-arm64.tar.gz"
    sha256 "fbbf9c0e334512ac2ed163a4197dddf0a94d55c2067a0c54ac6b97ea2a5815d4"
  elsif Hardware::CPU.intel?
    url "https://github.com/smartcrabai/codexbar-to-greptimedb/releases/download/v0.1.8/codexbar-to-greptimedb-0.1.8-macos-x86_64.tar.gz"
    sha256 "878cb772ac7e9355a7872d93281a8ca709c0f4065640b3786e4a9718c8f6af3b"
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
