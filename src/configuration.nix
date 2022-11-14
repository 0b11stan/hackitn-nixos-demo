{
  config,
  lib,
  pkgs,
  ...
}: let
  secretMySQLRootPassword = builtins.getEnv "MYSQL_ROOT_PASSWORD";
  secretMySQLPassword = builtins.getEnv "MYSQL_PASSWORD";
in {
  imports = [./hardware-configuration.nix];

  networking = {
    hostName = "nixos-harden";
    networkmanager.enable = true;
    useDHCP = lib.mkDefault true;
    firewall = {
      enable = true;
      allowedTCPPorts = [8080 22];
    };
  };

  time.timeZone = "Europe/Paris";

  console = {
    font = "Lat2-Terminus16";
    keyMap = "fr";
  };

  services.openssh = {
    enable = true;
    passwordAuthentication = false;
    permitRootLogin = "no";
  };

  virtualisation.docker.enable = true;

  users.users = {
    tristan = {
      isNormalUser = true;
      extraGroups = ["wheel" "docker"];
      packages = [pkgs.neovim];
      openssh.authorizedKeys.keyFiles = [./ssh-keys/silver-hp.pub];
    };
  };

  nixpkgs.overlays = [
    (self: super: {
      docker-nextcloud = super.callPackage ./docker-nextcloud.nix {};
    })
  ];

  environment.systemPackages = [pkgs.docker-nextcloud];

  systemd.services.nextcloud = {
    enable = true;
    restartIfChanged = true;
    wantedBy = ["multi-user.target"];
    after = ["docker.service"];
    bindsTo = ["docker.service"];
    documentation = ["https://github.com/0b11stan/docker-nextcloud"];
    script = "${pkgs.docker-nextcloud}/docker-nextcloud.sh";
    environment = {
      MYSQL_ROOT_PASSWORD = secretMySQLRootPassword;
      MYSQL_PASSWORD = secretMySQLPassword;
    };
  };

  system.stateVersion = "22.05"; # DO NOT MODIFY
}
