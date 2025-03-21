{ pkgs, lib, config, inputs, ... }:

let
  pkgs-unstable = import inputs.nixpkgs-unstable {
    inherit (pkgs.stdenv) system;
  };

  libraries = with pkgs; if (pkgs.stdenv.system == "x86_64-linux") then [
    xorg.libX11
    xorg.libXcursor
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXinerama
    xorg.libXrandr
    xorg.libXrender
    glibc
    libGL
    libxkbcommon
    wayland
  ] else [];
in
{
  # https://devenv.sh/packages/
  packages = with pkgs; [
    git
    wayland-scanner
  ] ++ libraries;
  env = {
    LD_LIBRARY_PATH = lib.makeLibraryPath libraries;
  };
  
  languages.zig = {
    enable = true;
    package = pkgs-unstable.zig;
  };
}
