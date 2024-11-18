{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils, ... }: flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in
      {
        devShell = pkgs.mkShell rec {
          k_deps = with pkgs; [
            pkg-config
            
            xorg.xorgproto
            xorg.libX11
            xorg.libX11.dev
            xorg.libxcb
            xorg.libxcb.dev
            xorg.libXext
            xorg.libXft
            xorg.libXinerama
            xorg.libXpm
            xorg.libXrandr
            xorg.libXrender
            xorg.libXau
            xorg.libXcursor
            xorg.libXi
            xorg.libXi.dev
            xorg.libXfixes
            xorg.libXxf86vm
            xorg.xinput
            xorg.libICE
            xorg.libXScrnSaver
            libdrm
            libGL
            libGL.dev
            libGLU
            libglvnd
            libglvnd.dev
            libxkbcommon
            mesa
            egl-wayland
            egl-wayland.dev
            wayland
            wayland-scanner
            alsa-lib
            audiofile
            dbus
            libdecor
            pipewire
            udev
            renderdoc
            vulkan-headers
            vulkan-helper
            vulkan-loader
            vulkan-tools
            vulkan-volk
          ];
          shellHook = ''
            export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${
              with pkgs;
              lib.makeLibraryPath k_deps
            }"
          '';
          packages = (with pkgs; [
            gdb
            gcc
            libtool
            gnumake
            cmake

            jetbrains.clion
          
            reaper # not free!
            yabridge
            # pending https://github.com/NixOS/nixpkgs/issues/281567

            blender
            ffmpeg-full
            yt-dlp

            # CV tasks
            (python311.withPackages (pp: [
              pp.scipy
              pp.numpy
              pp.autograd
              pp.matplotlib
              pp.notebook
              pp.jupyterlab
              pp.ipympl
              pp.ipykernel
              pp.scikit-learn
              pp.torch-bin
              pp.torchvision-bin
              pp.tqdm
              (pp.timm.override { torch = pp.torch-bin; torchvision = pp.torchvision-bin; })
              (pp.opencv4.override { enableGtk3 = true; enableUnfree = true; })
            ]))
          ]) ++ k_deps;
        };
      });
}

