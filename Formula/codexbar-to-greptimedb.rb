class CodexbarToGreptimedb < Formula
  desc "Export CodexBar usage snapshots to GreptimeDB"
  homepage "https://github.com/takumi3488/codexbar-to-greptimedb"
  version "0.1.1"
  license "Apache-2.0"
  depends_on macos: :sonoma

  if Hardware::CPU.arm?
    url "https://github.com/takumi3488/codexbar-to-greptimedb/releases/download/v0.1.1/codexbar-to-greptimedb-0.1.1-macos-arm64.tar.gz"
    sha256 "1367daca53c40ef19a1afd5b0d65b3436f6d7563e76be1d1183a62cfd196b3e9"
  elsif Hardware::CPU.intel?
    url "https://github.com/takumi3488/codexbar-to-greptimedb/releases/download/v0.1.1/codexbar-to-greptimedb-0.1.1-macos-x86_64.tar.gz"
    sha256 "48a862342e2700f2cc2796dd98f222e6043fc8bba91fcd1fd52f440272431ef7"
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
