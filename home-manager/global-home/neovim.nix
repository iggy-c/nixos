{ pkgs, ... }:

{
  programs = {
    git.settings.core.editor = "nvim";

    neovim = {
      enable = true;
      defaultEditor = true;

      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;

      plugins = with pkgs.vimPlugins; [
        # theme
        gruvbox

        # web
        coc-html

        # python
        coc-pyright

        # other
        coc-sh
        coc-json
        coc-docker
        coc-git

        nvim-treesitter.withAllGrammars

        nvim-colorizer-lua

      ];

      extraConfig = ''
                set ai
        	set cursorline
        	set number
        	set wildmode=longest,list
        	set tabstop=4
      '';

      extraLuaConfig = ''
        	vim.o.background = "dark"
                vim.g.gruvbox_background = "soft"
                vim.cmd("colorscheme gruvbox")
        	require'colorizer'.setup()
      '';

      coc = {
        enable = true;
        settings = {
          languageserver = {
            rust = {
              command = "rust-analyzer";
              args = [ ];
              rootPatterns = [
                "*.rs"
              ];
              filetypes = [ "rust" ];
            };

            nix = {
              command = "nil";
              args = [ ];
              filetypes = [ "nix" ];
              settings.nil.nix.flake.autoArchive = true;
            };
          };
          coc.preferences.formatOnType = true;
        };
      };
    };
  };
}
