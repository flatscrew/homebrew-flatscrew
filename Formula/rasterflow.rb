class Rasterflow < Formula
  desc "RasterFlow"
  homepage "https://github.com/flatscrew/rasterflow"
  url "https://github.com/flatscrew/rasterflow/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "1227642504f86e335e734cabf3ce0cea3d724c06c1c69f30fad63ed6358516f2"
  license "GPL-3.0"

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build

  # runtime deps
  depends_on "glib"
  depends_on "gtk4"
  depends_on "libadwaita"
  depends_on "libgee"
  depends_on "json-glib"
  depends_on "gegl"
  depends_on "gobject-introspection"

  # libgtkflow4 dependencies
  depends_on "flatscrew/osx/libgflow"
  depends_on "flatscrew/osx/libgtkflow4"

  def install
    system "meson", "setup", "build", *std_meson_args, "-Dcompile_gschemas=false"
    system "meson", "compile", "-C", "build"
    system "meson", "install", "-C", "build"
  end
  
  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{share}/glib-2.0/schemas"
  end

  test do
    system "#{bin}/rasterflow", "--version"
  end
end
