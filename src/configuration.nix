{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos-harden";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Paris";

  console = {
    font = "Lat2-Terminus16";
    keyMap = "fr";
  };

  virtualisation.docker.enable = true;

  users.users = {
    tristan = {
      isNormalUser = true;
      extraGroups = ["wheel" "docker"];
    };
    appuser = {
      isNormalUser = true;
      extraGroups = ["docker"];
    };
  };

  environment.systemPackages = with pkgs; [
    vim
    curl
  ];

  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}
