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

        nvim-colorizer-lua #the catgoose one

        hmts-nvim

		blink-indent
		guess-indent-nvim
      ];

      extraConfig = ''
        set ai
        set cursorline
        set number
        set wildmode=longest,list
		set expandtab
		set shiftwidth=4
        set tabstop=4
        set signcolumn=yes
        set clipboard+=unnamedplus
      '';

      extraLuaConfig = ''
        vim.o.background = "dark"
        vim.g.gruvbox_background = "soft"
        vim.cmd("colorscheme gruvbox")
        require'colorizer'.setup({
          user_default_options = {
            names = false,
          }
        })

        local neo_enabled = true
        vim.keymap.set('n', '<leader>tn', function()
          if neo_enabled then
            vim.cmd('CocCommand document.toggleInlayHint')
            neo_enabled = false
            vim.notify("Neo features OFF")
          else
            vim.cmd('CocEnable')
            vim.cmd('CocCommand document.toggleInlayHint')
            neo_enabled = true
            vim.notify("Neo features ON")
          end
        end, { desc = "Toggle neo features (inlay hints)" })
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
