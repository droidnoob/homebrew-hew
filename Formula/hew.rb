class Hew < Formula
  desc "Carve code, not chaos — Beads-powered methodology for AI coding agents."
  homepage "https://github.com/droidnoob/hew"
  version "0.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/droidnoob/hew/releases/download/v0.2.1/hew-aarch64-apple-darwin.tar.xz"
      sha256 "704acfc9e0982adf3980185607ff586f3149af63e76d1b2a050a60795f5b8cbb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/droidnoob/hew/releases/download/v0.2.1/hew-x86_64-apple-darwin.tar.xz"
      sha256 "69ace227043caab59b7a9c8ecd2b173b76e9bf35635345c831d5a069a849db6b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/droidnoob/hew/releases/download/v0.2.1/hew-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "bd1e3fb8783ce93f22a3480df50dcc01fb9cbfccf8e46b6695e8713365150f79"
    end
    if Hardware::CPU.intel?
      url "https://github.com/droidnoob/hew/releases/download/v0.2.1/hew-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "863005d96994415eb29978b4de49672f8c2dee803b2d96752c7fc36521c39fb2"
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
