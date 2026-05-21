class Hew < Formula
  desc "Carve code, not chaos — Beads-powered methodology for AI coding agents."
  homepage "https://github.com/droidnoob/hew"
  version "0.6.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/droidnoob/hew/releases/download/v0.6.0/hew-aarch64-apple-darwin.tar.xz"
      sha256 "8da850dfdef320c770d8d032cfc156dc8c8f94a4352803ba6af68e6318059e9a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/droidnoob/hew/releases/download/v0.6.0/hew-x86_64-apple-darwin.tar.xz"
      sha256 "f645534bd324d63bdf4a358e3e96fc476a80ff4dd1b3aae453690476c20fab19"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/droidnoob/hew/releases/download/v0.6.0/hew-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "32bda9dae3d495fce703e0fb5f1e42e962a09129ddc891995cd9295f7049a5bb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/droidnoob/hew/releases/download/v0.6.0/hew-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2f019789f4438289ae85ddcc4ae87d0eab11e488bc771f1de7d8bc3cdf53c2d6"
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
