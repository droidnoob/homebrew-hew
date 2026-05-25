class Hew < Formula
  desc "Carve code, not chaos — Beads-powered methodology for AI coding agents."
  homepage "https://github.com/droidnoob/hew"
  version "0.8.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/droidnoob/hew/releases/download/v0.8.1/hew-aarch64-apple-darwin.tar.xz"
      sha256 "edc8ee185dff3651d6562593febc6186520bf243c7f69d3b11da093dfb1eb536"
    end
    if Hardware::CPU.intel?
      url "https://github.com/droidnoob/hew/releases/download/v0.8.1/hew-x86_64-apple-darwin.tar.xz"
      sha256 "eb33aa5fdeddefee4abbf7d9ac4213c60d41af5b7b7e50c9713a356d59236f70"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/droidnoob/hew/releases/download/v0.8.1/hew-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ec5304644c9843280898cf0a9302e6eb970d04641650f45386d96d1339735374"
    end
    if Hardware::CPU.intel?
      url "https://github.com/droidnoob/hew/releases/download/v0.8.1/hew-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4e146e0fdfcd741b6fb52e73e362d9d79ffdc1e473cdb33fecbff0c17174dbad"
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
    bin.install "hew" if OS.mac? && Hardware::CPU.arm?
    bin.install "hew" if OS.mac? && Hardware::CPU.intel?
    bin.install "hew" if OS.linux? && Hardware::CPU.arm?
    bin.install "hew" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
