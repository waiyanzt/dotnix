{ config, pkgs, ... }:

{
  # XDG default applications
  xdg.mime = {
    enable = true;
    defaultApplications = {
      "text/plain" = "zed.desktop";
      "text/html" = "zen.desktop";
      "x-scheme-handler/http" = "zen.desktop";
      "x-scheme-handler/https" = "zen.desktop";
      "x-scheme-handler/about" = "zen.desktop";
      "x-scheme-handler/unknown" = "zen.desktop";
    };
  };

  environment.sessionVariables = {
    EDITOR = "zeditor";
    VISUAL = "zeditor";
    BROWSER = "zen";
  };
}
