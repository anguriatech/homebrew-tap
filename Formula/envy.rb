class Envy < Formula
  desc "A secure, deterministic, and frictionless environment variable manager"
  homepage "https://github.com/anguriatech/envy"
  version "0.2.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/anguriatech/envy/releases/download/v0.2.7/envy-aarch64-apple-darwin.tar.xz"
      sha256 "0bac265e793a92c6c236fe3138f01fada5d004e8f6fbd27ebf55b17b019f25c0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/anguriatech/envy/releases/download/v0.2.7/envy-x86_64-apple-darwin.tar.xz"
      sha256 "0a28c89cf487119c51798a52b252708a2e7c07c9303d6a065151b53866e237e5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/anguriatech/envy/releases/download/v0.2.7/envy-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c9595e47e3221b7c64b77450088fd980a4dd1c67e62ea8bd4474e74d51aef4c2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/anguriatech/envy/releases/download/v0.2.7/envy-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1461c4f0346742b576025d6e18321e3614955aa0e596d0d5c57dba863e1d341c"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
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
    bin.install "envy" if OS.mac? && Hardware::CPU.arm?
    bin.install "envy" if OS.mac? && Hardware::CPU.intel?
    bin.install "envy" if OS.linux? && Hardware::CPU.arm?
    bin.install "envy" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
