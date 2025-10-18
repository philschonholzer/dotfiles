AGENT QUICKSTART (keep ~20 lines)

Build / Lint / Test:
1. Nix flake eval: nix flake show
2. Rebuild NixOS host: sudo nixos-rebuild switch --flake .#nixos
3. Darwin home build: home-manager switch --flake .#philip
4. Format Nix: nix fmt (alejandra) / or: alejandra .
5. Neovim config: launch nvim (lazy manages plugins). Update plugins: :Lazy sync
6. Lua formatting: stylua . (config in nvim/stylua.toml)
7. Lint Lua (via LSP): lua-language-server (configured in lua-lang.lua)
8. Run a single Neovim test (if added): nvim --headless -c "PlenaryBustedFile tests/<file>.lua" -c qa

Style & Conventions:
9. Nix: pure, declarative; keep inputs pinned in flake.nix, no imperative nix-env.
10. Formatting: Use alejandra for .nix, stylua (2-space, width 120) for Lua.
11. Imports: Prefer local relative Lua requires (e.g. require("config.lazy")). Group plugin specs; early returns allowed (see example.lua).
12. Naming: snake_case for Lua variables/functions; UpperCamelCase for modules if exported; Nix attributes are lowercase-hyphen or snake_case.
13. Types / annotations: Use EmmyLua @type hints where helpful (see opts functions). Avoid unused params (prefix _).
14. Error handling: Fail fast for bootstrap (see lazy.lua clone logic); otherwise surface via vim.notify or propagate.
15. Keep plugin specs minimal; optional=true when extending existing plugins; do not duplicate ensure_installed entries (filter as in biomejs.lua).
16. Do not commit secrets; emails only in flake outputs metadata.
17. Prefer declarative configuration over ad-hoc commands; add tools via home-manager extraPackages.
18. PRs: concise commits explaining why (not just what). Run formatters before commit.
19. If adding tests, colocate under tests/ and support headless invocation as in line 8.
20. No .cursor or Copilot rule files present; none to replicate.
