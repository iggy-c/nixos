{pkgs, ...}: {
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

        -- Toggle neo features (CoC LSP + treesitter highlight) with <leader>tn
        local neo_enabled = true
        vim.keymap.set('n', '<leader>tn', function()
          if neo_enabled then
            vim.cmd('CocDisable')
            vim.cmd('TSDisable highlight')
            vim.cmd('TSBufDisable highlight')
            neo_enabled = false
            vim.notify("Neo features OFF")
          else
            vim.cmd('CocEnable')
            vim.cmd('TSEnable highlight')
            vim.cmd('TSBufEnable highlight')
            neo_enabled = true
            vim.notify("Neo features ON")
          end
        end, { desc = "Toggle neo features (LSP + treesitter)" })
      '';

      coc = {
        enable = true;
        settings = {
          languageserver = {
            rust = {
              command = "rust-analyzer";
              args = [];
              rootPatterns = [
                "*.rs"
              ];
              filetypes = ["rust"];
            };

            nix = {
              command = "nil";
              args = [];
              filetypes = ["nix"];
              settings.nil.nix.flake.autoArchive = true;
            };
          };
          coc.preferences.formatOnType = true;
        };
      };
    };
  };
}
