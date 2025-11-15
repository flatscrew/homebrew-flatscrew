class Rasterflow < Formula
  desc "RasterFlow"
  homepage "https://github.com/flatscrew/rasterflow"
  url "https://github.com/flatscrew/rasterflow/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "c9d3ab6c87df1e75eb0acc44118f37ea45a1833b853aace26413fab22d06a35a"
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

  # your libraries (internal to your tap)
  depends_on "flatscrew/libgflow/libgflow"
  depends_on "flatscrew/libgtkflow4/libgtkflow4"

  # if rasterflow uses GObject-introspection (very likely)
  depends_on "gobject-introspection"

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build"
    system "meson", "install", "-C", "build"
  end

  test do
    system "#{bin}/rasterflow", "--version"
  end
end
