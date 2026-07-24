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

        nvim-ufo
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
        set lbr
        set ignorecase
        set smartcase
        set foldlevel=99
        set foldlevelstart=99
        set foldenable
        set foldcolumn=1
        set cinoptions+=+0
        map <F1> <Esc>
        imap <F1> <Esc>
        :map <MiddleMouse> <Nop>
        :imap <MiddleMouse> <Nop>
      '';

      initLua = ''
        vim.o.termguicolors = true
        vim.o.background = "dark"
        vim.g.gruvbox_background = "soft"
        vim.cmd("colorscheme gruvbox")
        require'colorizer'.setup({
            user_default_options = {
                names = false,
            }
        })


        -- todo: fix below
        local hints_enabled = true
        vim.keymap.set('n', '<leader>th', function()
            if hints_enabled then
                vim.cmd('CocCommand document.toggleInlayHint')
                hints_enabled = false
                vim.notify("Type hints OFF")
            else
                vim.cmd('CocCommand document.toggleInlayHint')
                hints_enabled = true
                vim.notify("Type hints ON")
            end
        end, { desc = "Toggle inlay hints" })

        local autocomplete_enabled = true
        vim.keymap.set('n', '<leader>ta', function()
            if autocomplete_enabled then
                vim.cmd('CocDisable')
                autocomplete_enabled = false
                vim.notify("Autocompletion OFF")
            else
                vim.cmd('CocEnable')
                autocomplete_enabled = true
                vim.notify("Autocompletion ON")
            end
        end, { desc = "Toggle autocomplete" })

        require'guess-indent'.setup()

        require'ufo'.setup({
            provider_selector = function(bufnr, filetype, buftype)
                return { 'treesitter', 'indent' }
            end,
        })
        vim.keymap.set('n', 'zR', require'ufo'.openAllFolds)
        vim.keymap.set('n', 'zM', require'ufo'.closeAllFolds)
        vim.o.fillchars = 'eob: ,fold: ,foldopen:,foldsep: ,foldinner: ,foldclose:'
        -- weird override for copying to system clipboard (riley dont blind copy)
        vim.keymap.set({'n', 'x'}, 'Y', '"+y')
        vim.keymap.set('n', 'YY', '"+yy')
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
