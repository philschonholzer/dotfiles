Is used in NixOS, Fedora (Home Manager) and Darwin. The config needs to work an all 3 platforms.

The config is using the Dendritic pattern (see <https://dendrix.denful.dev/Dendritic.html>).

After you are finished with a change:

1. Format with `nixfmt`
2. Stage the changes (otherwise nix will not see the new files)
3. Use `nix flake check` to check the config -> Fix if problems exist
4. Ask if the changes should be commited (use conventional commits)

If you can not see in the stack trace where a build error is coming use: `--show-trace`
