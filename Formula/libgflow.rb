class Libgflow < Formula
  desc "Non-visual computational core for GTKFlow: node graphs, data propagation, evaluation"
  homepage "https://github.com/flatscrew/libgflow"
  url "https://github.com/flatscrew/libgflow/archive/refs/tags/v1.0.tar.gz"
  sha256 "f1c9237eba0bd3556ec504b4a40ebf58af4f625b6e9a94d422d1c8d60a81605f"
  license "GPL-3.0"

  depends_on "vala" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "gobject-introspection"

  def install
    system "meson", "setup", "build", *std_meson_args, "-Denable_valadoc=false"
    system "meson", "compile", "-C", "build"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gflow/gflow.h>
      int main() { return 0; }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lgflow-1.0", "-o", "test"
    system "./test"
  end
end
