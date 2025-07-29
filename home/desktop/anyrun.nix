{ pkgs
, inputs
, config
}:
let
  inherit (config.gui.theme) colors;
in
{
  enable = true;

  config = {
    plugins = [ "applications" "rink" "randr" "shell" ];

    width.fraction = 0.3;
    hidePluginInfo = true;
    closeOnClick = true;
  };

  extraConfigFiles = {
    "applications.ron".text = ''
      Config(
        desktop_actions: true,
        max_entries: 5,
        terminal: Some("wezterm"),
      )
    '';
    "shell.ron".text = ''
      Config(
        prefix: "c",
      )
    '';
    "randr.ron".text = ''
      Config(
        prefix: "r",
        max_entries: 5,
      )
    '';
  };

  # TODO: define from colorscheme
  extraCss = ''
    * {
      all: unset;
      font-size: 1.3rem;
      color: ${colors.base07};
    }

    #match.activatable {
      border-radius: 5px;
      padding: 0.3rem 0.9rem;
      margin-top: 0.01rem;
    }
    #match.activatable:first-child {
      margin-top: 0.7rem;
    }
    #match.activatable:last-child {
      margin-bottom: 0.6rem;
    }

    #plugin:hover #match.activatable {
      border-radius: 10px;
      padding: 0.3rem;
      margin-top: 0.01rem;
      margin-bottom: 0;
    }

    #match:selected,
    #match:hover,
    #plugin:hover {
      background: ${colors.base02};
    }

    #entry {
      background: ${colors.base01};
      border-radius: 5px;
      margin: 0.5rem;
      padding: 0.5rem 1rem;
    }

    list > #plugin {
      border-radius: 16px;
      margin: 0 0.3rem;
    }
    list > #plugin:first-child {
      margin-top: 0.3rem;
    }
    list > #plugin:last-child {
      margin-bottom: 0.3rem;
    }
    list > #plugin:hover {
      padding: 0.6rem;
    }

    box#main {
      background: ${colors.base00};
      border-radius: 5px;
      padding: 0.3rem;
    }
  '';

}
