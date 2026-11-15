# Home Manager aspects

Each home configuration imports `base` and its platform aspect:

| Platform | Platform aspect | Inherits |
| --- | --- | --- |
| NixOS | `nixos` | `linux` |
| Fedora and other standalone Linux environments | `genericLinux` | `linux` |
| macOS | `darwin` | No Linux settings |

`linux.nix` connects both Linux platform aspects to `linux`, so individual
hosts do not need another import. New Linux hosts should import either
`nixos` or `genericLinux` alongside `base`.

In each feature file, put shared settings in `flake.modules.homeManager.base`
and Linux-only settings in `flake.modules.homeManager.linux`, rather than
guarding each setting with `isLinux`. Keep NixOS-specific integration in
`nixos` and standalone Linux integration in `genericLinux`.

Use `lib.mkDefault` for shared defaults that platform aspects need to override.
