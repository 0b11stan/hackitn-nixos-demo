{
  pkgs,
  fetchFromGitHub,
  ...
}: let
  core = "${pkgs.coreutils}/bin";
  argProjectName = "--project-name '$name'";
  argComposeFile = "--file '$src/docker-compose.yml'";
  dockercmd = "compose ${argProjectName} ${argComposeFile} up -d";
in
  derivation {
    name = "docker-nextcloud";

    system = builtins.currentSystem;

    src = fetchFromGitHub {
      owner = "0b11stan";
      repo = "docker-nextcloud";
      rev = "main";
      sha256 = "sha256-u5TT0Y1twaNlNPmTzcfjRMx2ZD6mRMgzD65eYvhwjXo=";
    };

    builder = "${pkgs.bash}/bin/bash";

    args = [
      "-c"
      ''
        ${core}/mkdir $out \
          && echo "${pkgs.docker}/bin/docker ${dockercmd}" \
          > $out/$name.sh \
          && ${core}/chmod +x $out/$name.sh
      ''
    ];
  }
