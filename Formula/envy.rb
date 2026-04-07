class Envy < Formula
  desc "A secure, deterministic, and frictionless environment variable manager"
  homepage "https://github.com/anguriatech/envy"
  version "0.2.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/anguriatech/envy/releases/download/v0.2.6/envy-aarch64-apple-darwin.tar.xz"
      sha256 "2b60c17d3aab06b2a12b41980c0b5858f668bc0e038594e34a80fbc7a7e684d8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/anguriatech/envy/releases/download/v0.2.6/envy-x86_64-apple-darwin.tar.xz"
      sha256 "c2c164b2a15feb81639a6192cc34e196f58c77ebb04c44a802d9fb2b75e0c60d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/anguriatech/envy/releases/download/v0.2.6/envy-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "83562a66c81b3e66ada4bd05e34e985137dde41e09e0e212196404fdea985549"
    end
    if Hardware::CPU.intel?
      url "https://github.com/anguriatech/envy/releases/download/v0.2.6/envy-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5bab5dc0075c88ff464b0b1868c9a6b10d712ad583d5baba476795088c58be6a"
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
