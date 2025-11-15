class Libgtkflow4 < Formula
  desc "GTK4-based visual node editor for libgflow"
  homepage "https://github.com/flatscrew/libgtkflow4"
  url "https://github.com/flatscrew/libgtkflow4/archive/refs/tags/v0.2.tar.gz"
  sha256 "a86130f23504e61e27dd2dd9a7277c83d3e222890fed7b11adcd66b33d4306ad"
  license "GPL-3.0"

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build 
  depends_on "glib"
  depends_on "gtk4"
  depends_on "gobject-introspection"
  depends_on "flatscrew/flatscrew/libgflow"

  def install
    system "meson", "setup", "build", *std_meson_args, "-Denable_valadoc=false"
    system "meson", "compile", "-C", "build"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gtkflow4/gtkflow4.h>
      int main() { return 0; }
    EOS

    system ENV.cc, "test.c",
           "-I#{include}",
           "-L#{lib}",
           "-lgtkflow4",
           "-o", "test"
    system "./test"
  end
end
