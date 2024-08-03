{ lib, config, inputs, ... }:
let
  username = "filesystem";
  hostname = config.networking.hostName;
in
{
  options.usermgmt.${username} = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };

  config = lib.mkIf config.usermgmt.${username}.enable {
    sops.secrets."${hostname}/${username}/password".neededForUsers = true;
    
    users.users.${username} = {
      isNormalUser = true;
      description = username;
      hashedPasswordFile = config.sops.secrets."${hostname}/${username}/password".path;
    };

    home-manager.users.${username} = {
      home = {
        username = username;
        homeDirectory = "/home/${username}";
        stateVersion = "24.05";
      };

      imports = [
        ../programs/default.nix
      ];
      homepkgs.hostname = hostname;

      sops = {
        age.keyFile = "/home/${username}/.config/sops/age/keys.txt";
        defaultSopsFile = "${inputs.nix-secrets}/secrets.yaml";
      };

      programs.bash.enable = true;
    };
  };
}
