{ pkgs, inputs, ... }:
let 
  system = pkgs.stdenv.hostPlatform.system;

in
{
  home.packages = [
    inputs.claude-desktop.packages.${system}.claude-desktop-with-fhs
  ];

  home.file."Claude/claude_desktop_config.json".text = ''
    {
      "mcpServers": {
        "my-server": {
          "command": "npx",
          "args": [
            "mcp-remote@latest",
            "http://localhost:8000/mcp"
          ]
        }
      },
      "preferences": {},
      "globalShortcut": "Alt+Ctrl+Space"
    } 
  '';
}
