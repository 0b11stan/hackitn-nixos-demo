# Nixos Harden

## Installation

Follow the [default installation](https://nixos.org/manual/nixos/stable/index.html#sec-installation-manual-summary).

As a first configuration write the following:

```nix
{ config, pkgs, ... }:
{
  imports = [./hardware-configuration.nix];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.networkmanager.enable = true;
  networking.firewall.enable = false;
  services.openssh.enable = true;
  users.users.tristan = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };
  system.stateVersion = "22.05";

}
```

Apply configuration (ask root password at the end)

```bash
nixos-install
```

Reboot, then, change user's password

```bash
passwd tristan
```

## Goals

* [x] download isos
* [x] create vm, install nixos
* [x] connect to ssh server
* [x] setup dev process
* [x] install docker
* [x] create docker-nextcloud derivation
* [x] install docker-nextcloud as systemd unit
* [x] harden firewall
* [x] harden ssh
* [ ] harden system as ANSSI

## Ressources

* [installation](https://nixos.org/manual/nixos/stable/index.html#sec-installation-manual-summary)
* [nixos wiki: security](https://nixos.wiki/wiki/Security)
* [ANSSI on GNU/Linux Security](https://www.ssi.gouv.fr/guide/recommandations-de-securite-relatives-a-un-systeme-gnulinux/)
* [ANSSI on OpenSSH](https://www.ssi.gouv.fr/guide/recommandations-pour-un-usage-securise-dopenssh/)
