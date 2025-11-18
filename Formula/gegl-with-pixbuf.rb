class GeglWithPixbuf < Formula
    desc "Graph based image processing framework"
    homepage "https://www.gegl.org/"
    url "https://download.gimp.org/pub/gegl/0.4/gegl-0.4.64.tar.xz"
    sha256 "0de1c9dd22c160d5e4bdfc388d292f03447cca6258541b9a12fed783d0cf7c60"
    license all_of: ["LGPL-3.0-or-later", "GPL-3.0-or-later", "BSD-3-Clause", "MIT"]
    head "https://gitlab.gnome.org/GNOME/gegl.git", branch: "master"
  
    livecheck do
      url "https://download.gimp.org/pub/gegl/0.4/"
      regex(/href=.*?gegl[._-]v?(\d+(?:\.\d+)+)\.t/i)
    end
  
    depends_on "gettext" => :build
    depends_on "gobject-introspection" => :build
    depends_on "meson" => :build
    depends_on "ninja" => :build
    depends_on "pkgconf" => :build
  
    depends_on "babl"
    depends_on "cairo"
    depends_on "gdk-pixbuf"
    depends_on "glib"
    depends_on "jpeg-turbo"
    depends_on "json-glib"
    depends_on "libpng"
    depends_on "libtiff"
    depends_on "little-cms2"
  
    on_macos do
      depends_on "gettext"
    end
  
    on_linux do
      depends_on "poppler"
    end
  
    def install
      ### Temporary Fix ###
      # Temporary fix for a meson bug
      # Upstream appears to still be deciding on a permanent fix
      # See: https://gitlab.gnome.org/GNOME/gegl/-/issues/214
      inreplace "subprojects/poly2tri-c/meson.build",
        "libpoly2tri_c = static_library('poly2tri-c',",
        "libpoly2tri_c = static_library('poly2tri-c', 'EMPTYFILE.c',"
      touch "subprojects/poly2tri-c/EMPTYFILE.c"
      ### END Temporary Fix ###
  
      args = %w[
        -Ddocs=false
        -Djasper=disabled
        -Dumfpack=disabled
        -Dlibspiro=disabled
        --force-fallback-for=libnsgif,poly2tri-c
      ]
      system "meson", "setup", "build", *args, *std_meson_args
      system "meson", "compile", "-C", "build", "--verbose"
      system "meson", "install", "-C", "build"
    end
  
    test do
      (testpath/"test.c").write <<~C
        #include <gegl.h>
        gint main(gint argc, gchar **argv) {
          gegl_init(&argc, &argv);
          GeglNode *gegl = gegl_node_new ();
          gegl_exit();
          return 0;
        }
      C
      system ENV.cc, "test.c", "-o", "test",
                     "-I#{Formula["babl"].opt_include}/babl-0.1",
                     "-I#{Formula["glib"].opt_include}/glib-2.0",
                     "-I#{Formula["glib"].opt_lib}/glib-2.0/include",
                     "-I#{include}/gegl-0.4",
                     "-L#{lib}", "-lgegl-0.4",
                     "-L#{Formula["glib"].opt_lib}", "-lgobject-2.0", "-lglib-2.0"
      system "./test"
    end
  end
  