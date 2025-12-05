class Rasterflow < Formula
  desc "Node-based raster editor built on GTK4"
  homepage "https://github.com/flatscrew/rasterflow"
  url "https://github.com/flatscrew/rasterflow/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "b620a588d33f3d7f6b4b476ddaa9b574c0a87268252cc332cd30b75f03397d2f"
  license "GPL-3.0"

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build

  depends_on "flatscrew/osx/gegl-with-pixbuf"
  depends_on "flatscrew/osx/libgflow"
  depends_on "flatscrew/osx/libgtkflow4"

  depends_on "glib"
  depends_on "gobject-introspection"
  depends_on "gtk4"
  depends_on "json-glib"

  depends_on "libadwaita"
  depends_on "libgee"

  def install
    system "meson", "setup", "build", *std_meson_args, "-Dcompile_gschemas=false"
    system "meson", "compile", "-C", "build"
    system "meson", "install", "-C", "build"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", HOMEBREW_PREFIX/"share/glib-2.0/schemas"
  end

  test do
    system "#{bin}/rasterflow", "--version"
  end
end
