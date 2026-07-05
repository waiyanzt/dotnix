# Archived Hyprland user configuration.
#
# Import this module from home/ztzy.nix when returning to Hyprland:
#
#   imports = [
#     ./shared.nix
#     ./hyprland.nix
#   ];
{
  home.file = {
    ".config/hypr/hyprland.conf".source = ../.config/hypr/hyprland.conf;
    ".config/hypr/hyprlock.conf".source = ../.config/hypr/hyprlock.conf;
    ".config/hypr/hypridle.conf".source = ../.config/hypr/hypridle.conf;

    ".config/waybar/config.jsonc".source = ../.config/waybar/config.jsonc;
    ".config/waybar/style.css".source = ../.config/waybar/style.css;
    ".config/waybar/scripts/toggle.sh" = {
      source = ../.config/waybar/scripts/toggle.sh;
      executable = true;
    };

    ".config/swaync/config.json".source = ../.config/swaync/config.json;
    ".config/swaync/style.css".source = ../.config/swaync/style.css;
    ".config/wlogout/layout".source = ../.config/wlogout/layout;
    ".config/kanshi/config".source = ../.config/kanshi/config;

    "dotnix/assets/nix-snowflake.svg".source = ../assets/nix-snowflake.svg;
  };
}
