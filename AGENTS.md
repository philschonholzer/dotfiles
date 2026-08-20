Is used in NixOS, Fedora (Home Manager) and Darwin. The config needs to work an all 3 platforms.

The config is using the Dendritic pattern (see <https://dendrix.denful.dev/Dendritic.html>).

After you are finished with a change:

1. Format with `nixfmt`
2. Stage the changes (otherwise nix will not see the new files)
3. Use `nix flake check` to check the config -> Fix if problems exist
4. Ask if the changes should be commited (use conventional commits)

If you can not see in the stack trace where a build error is coming use: `--show-trace`

When looking up NixOS or home-manager options, packages, or anything related to nixpkgs,
always use the nixos MCP tool first. It queries live APIs and is faster and more accurate
than searching the nix store manually or using `nix search`.

Examples:
- "is package X available?" -> nix {"action":"info","query":"X"}
- "home-manager option for X" -> nix {"action":"search","source":"home-manager","query":"X"}
- "NixOS option for X" -> nix {"action":"search","query":"X","type":"options"}

