class Hew < Formula
  desc "Carve code, not chaos — Beads-powered methodology for AI coding agents."
  homepage "https://github.com/droidnoob/hew"
  version "0.8.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/droidnoob/hew/releases/download/v0.8.0/hew-aarch64-apple-darwin.tar.xz"
      sha256 "0514b981f7a33003267cebd3de947f3d0c975a4767b4ad9f1839cb8bb839f349"
    end
    if Hardware::CPU.intel?
      url "https://github.com/droidnoob/hew/releases/download/v0.8.0/hew-x86_64-apple-darwin.tar.xz"
      sha256 "98dbac891f09f1bd5db48c502de9242e0a9ce483f7c4f7cef42c67d8b6c53192"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/droidnoob/hew/releases/download/v0.8.0/hew-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b5c6c529ca09ccb11e558947ab3ceafe950e484a86d761612f780af50d57d942"
    end
    if Hardware::CPU.intel?
      url "https://github.com/droidnoob/hew/releases/download/v0.8.0/hew-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "253f8e0c8bfb19fb55b309a160349c8d64657feb411391992962b352308d1b61"
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
