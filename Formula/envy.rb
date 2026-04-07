class Envy < Formula
  desc "A secure, deterministic, and frictionless environment variable manager"
  homepage "https://github.com/anguriatech/envy"
  version "0.2.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/anguriatech/envy/releases/download/v0.2.4/envy-aarch64-apple-darwin.tar.xz"
      sha256 "35458c825f73a8bd3515ca2d6fbb00ed10663d9f4a78e5782c0e08ed22ae873e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/anguriatech/envy/releases/download/v0.2.4/envy-x86_64-apple-darwin.tar.xz"
      sha256 "a317a99216cebc76111179d0a1b151da1c42a37c9ecbb76095a17fabe1d0d4f7"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/anguriatech/envy/releases/download/v0.2.4/envy-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "89cf66060d00e30f97b0a1abcc4cb6d977ca30567373f5ad429854f1a837734f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/anguriatech/envy/releases/download/v0.2.4/envy-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2c60d68cebd0d10e9b937cdf4aa05d931f41a34344078fdd7ab70374c8e729a1"
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
