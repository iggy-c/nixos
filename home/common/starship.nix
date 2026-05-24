{
  pkgs,
  lib,
  ...
}: {
  programs.starship = {
    enable = false;
    settings = {
      format = lib.concatStrings [
        "$\{custom.path\}"
        "$\{custom.path_readonly\}"
        "$direnv"
        "$nix_shell"
        "$git_branch"
        "$git_commit"
        "$git_state"
      ];
      add_newline = false;
      git_branch = {
        format = "[\\[$branch(:$remote_branch)\\] ]($style)";
        style = "bold green";
        disabled = false;
      };
      nix_shell = {
        format = "[\\[$state( \\($name\\))\\] ]($style)";
        style = "bold blue";
        disabled = false;
      };
      custom = {
        path = {
          command = "pwd";
          when = "test -w .";
          format = "[$output ]($style)";
          style = "bold yellow";
        };
        path_readonly = {
          command = "pwd";
          when = "! test -w .";
          format = "[$output ]($style)";
          style = "bold red";
        };
      };
      character = {
        format = "​";
        #         ↑ there is an invisible space here
        #           because starship sucks
        success_symbol = "";
        error_symbol = "";
      };
      direnv = {
        format = "[\\[$symbol$loaded$allowed\\]]($style) ";
        symbol = "direnv";
        allowed_msg = "";
        not_allowed_msg = " not allowed";
        denied_msg = " denied";
        loaded_msg = "";
        unloaded_msg = " not loaded";
        disabled = false;
      };
    };
  };
}
