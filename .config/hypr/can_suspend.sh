# exits with code zero if no important processes are running
[[ -z $(pgrep -l -f "flatpak (update|(un)?install|repair)") && -z $(pgrep -l "nixos-rebuild") && -z $(pgrep -l -f "nix-collect-garbage") && -z $(pgrep -l "nix-store") && -z $(pgrep -l "zypper") && -z $(pgrep -l "apt") ]]
