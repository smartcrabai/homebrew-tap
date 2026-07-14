class CodexbarToGreptimedb < Formula
  desc "Export CodexBar usage snapshots to GreptimeDB"
  homepage "https://github.com/takumi3488/codexbar-to-greptimedb"
  version "0.1.2"
  license "Apache-2.0"
  depends_on :macos

  on_macos do
    depends_on macos: :sonoma
  end

  if Hardware::CPU.arm?
    url "https://github.com/takumi3488/codexbar-to-greptimedb/releases/download/v0.1.2/codexbar-to-greptimedb-0.1.2-macos-arm64.tar.gz"
    sha256 "9fb49f093ae2273763d447ed38310aefff2c596d52fa9a0c66e6f2d515e4f559"
  elsif Hardware::CPU.intel?
    url "https://github.com/takumi3488/codexbar-to-greptimedb/releases/download/v0.1.2/codexbar-to-greptimedb-0.1.2-macos-x86_64.tar.gz"
    sha256 "99c458ce86b00356b623044d7c81e308397d45cc6100b8e35abefc9fee42c3db"
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
  end

  test do
    assert_match "--every-minute", shell_output("#{bin}/codexbar-to-greptimedb --help")
  end
end
