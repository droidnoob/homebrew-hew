class Hew < Formula
  desc "Carve code, not chaos — Beads-powered methodology for AI coding agents."
  homepage "https://github.com/droidnoob/hew"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/droidnoob/hew/releases/download/v0.1.0/hew-aarch64-apple-darwin.tar.xz"
      sha256 "4ffb48047406eef6dfa68943cbc7c86407e9fdc14a04b0239ff871cd9cdc077e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/droidnoob/hew/releases/download/v0.1.0/hew-x86_64-apple-darwin.tar.xz"
      sha256 "ee735ffcf92df8b33ed20a253903ee41dd6fc1a0154e95a5b78d903d7071b02d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/droidnoob/hew/releases/download/v0.1.0/hew-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d4eca44fb7e66d1a63c2508acb31a78957e6c548f5aac4c5b3430da86eed4e87"
    end
    if Hardware::CPU.intel?
      url "https://github.com/droidnoob/hew/releases/download/v0.1.0/hew-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8d38ce08f3695d6b45262a7d5b5433c26cb68196fafb8f4ecec0c64e33740f88"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin": {},
    "x86_64-pc-windows-gnu": {},
    "x86_64-unknown-linux-gnu": {}
  }

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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "hew"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "hew"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "hew"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "hew"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
