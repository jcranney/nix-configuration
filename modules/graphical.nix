{ den, ... }:
{
  den.aspects.graphical = {
    homeManager = { pkgs, config, ... }: {
      home.packages = with pkgs; [
        qbittorrent vscode arduino-ide kdePackages.yakuake
        openscad freecad prusa-slicer inkscape  # design/3d printing
        insync 
      ];
    };
  };
}