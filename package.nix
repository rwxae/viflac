{ pkgs, ... }:

pkgs.writeShellApplication {
  name = "viflac";
  runtimeInputs = with pkgs; [
    coreutils
    flac
    file
  ];
  text = builtins.readFile ./viflac.sh;
}
