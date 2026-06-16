class Envy < Formula
  desc "A secure, deterministic, and frictionless environment variable manager"
  homepage "https://github.com/anguriatech/envy"
  version "0.3.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/anguriatech/envy/releases/download/v0.3.2/envy-aarch64-apple-darwin.tar.xz"
      sha256 "3835941bb1a647535d46e6f84000c29f5107da250ce16547125f4408f5372ee3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/anguriatech/envy/releases/download/v0.3.2/envy-x86_64-apple-darwin.tar.xz"
      sha256 "d0a39f1c25a5605372872235c35d4d8da62c341869e107167f08e7b95a0fd0a7"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/anguriatech/envy/releases/download/v0.3.2/envy-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "27fd5d42e529d62c2eed082a887a1e7c145b07fee47ac98ab4a5f0f84614d69f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/anguriatech/envy/releases/download/v0.3.2/envy-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7f6e07d7ed0f71ca76392d79234d132ce40db1f04ee72fc81c6d9b73495c541c"
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
