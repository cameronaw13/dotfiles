{ lib, config, inputs, ... }:
{
  # TODO: Add centralized backup management and restarting with custom options
  options.servicemgmt.maintenance = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };

  config = lib.mkIf config.servicemgmt.maintenance.enable {
    nix.gc = {
      automatic = true;
      dates = "Mon *-*-* 01:40:00";
      options = "--delete-older-than 30d";
      persistent = true;
    };
    
    nix.optimise = {
      automatic = true;
      dates = [ "Mon *-*-* 01:50:00" ];
    };

    system.autoUpgrade = {
      enable = true;
      flake = inputs.self.outPath;
      flags = [
        # deprecated w/ no replacement lol
        "--update-input"
        "nixpkgs"
        "-L" # print build logs
      ];
      dates = "Mon *-*-* 02:00:00";
      persistent = true;
    };
  };
}
