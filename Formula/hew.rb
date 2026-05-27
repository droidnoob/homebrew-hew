class Hew < Formula
  desc "Carve code, not chaos — Beads-powered methodology for AI coding agents."
  homepage "https://github.com/droidnoob/hew"
  version "0.10.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/droidnoob/hew/releases/download/v0.10.0/hew-aarch64-apple-darwin.tar.xz"
      sha256 "442ceed7f596e4c8a6b8528f7d7d44a7abf4136dc0e373bae2c66934b40ed567"
    end
    if Hardware::CPU.intel?
      url "https://github.com/droidnoob/hew/releases/download/v0.10.0/hew-x86_64-apple-darwin.tar.xz"
      sha256 "c3689538102e1b36a745d102047a71e0b476b7067c63a102b51a628d98abf752"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/droidnoob/hew/releases/download/v0.10.0/hew-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "89a59dc7fef8f41e83471b59bd211a3957ec91dbee1ffd6106d04bd498ff2ef3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/droidnoob/hew/releases/download/v0.10.0/hew-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "32f3242d2b34b3563162125a513e201cd7a2d8bed7faf603c11a8d1dda62da7c"
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
