class Envy < Formula
  desc "A secure, deterministic, and frictionless environment variable manager"
  homepage "https://github.com/anguriatech/envy"
  version "0.2.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/anguriatech/envy/releases/download/v0.2.2/envy-aarch64-apple-darwin.tar.xz"
      sha256 "5089a764aa028f99f0d36ab198545ee6de367b7635b23f45f019b1089ab280d4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/anguriatech/envy/releases/download/v0.2.2/envy-x86_64-apple-darwin.tar.xz"
      sha256 "a047d6387462e7d346c5f32afeb672dd333b420b6b50fcbf43a4e59c2ac3b661"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/anguriatech/envy/releases/download/v0.2.2/envy-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6f6f7c56b898f90dfac69459e21192923fd4e5696c84649a7546f80fe1f8a1e1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/anguriatech/envy/releases/download/v0.2.2/envy-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9c75c6608ce01de7b6d901fb455ce376f597f825e463ff695e5fcc77863d46d8"
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
