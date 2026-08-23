{ shell, ... }:
{
  enable = (shell.name == "fish");
  interactiveShellInit = builtins.readFile ./config.fish;
  functions = {
    __fish_cmd_error.body = ''
      # TODO: make more interactive
    '';
    __fish_cmd_success.body = ''
      # TODO: make more interactive
    '';
  };
}
