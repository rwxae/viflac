{ pkgs, ... }:

pkgs.writeShellApplication {
  name = "viflac";
  runtimeInputs = with pkgs; [
    coreutils
    file
    flac
    gnused
  ];
  text = builtins.readFile ./viflac.sh;
}
