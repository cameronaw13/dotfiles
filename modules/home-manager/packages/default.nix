{ lib, ... }:
{
  imports = [
    ./vim.nix
    ./git.nix
    ./htop.nix
  ];

  # Setup togglable user-specific packages
  homepkgs = {
    vim.enable = lib.mkDefault false;
    git.enable = lib.mkDefault false;
    htop.enable = lib.mkDefault false;
  };
}
