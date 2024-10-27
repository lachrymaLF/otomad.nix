{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      fhs = pkgs.buildFHSUserEnv {
        name = "fhs-shell";
        targetPkgs = pkgs: with pkgs; [
          # dependencies for building K -- libraries are vendored
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
        ];
      };
    in
      {
        devShells.${system}.default = fhs.env;
      };
}
