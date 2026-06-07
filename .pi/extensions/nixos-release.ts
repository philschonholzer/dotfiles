import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";

const NIXOS_RELEASE = "nixos-26.05";

const NIXOS_RELEASE_INSTRUCTIONS = `
IMPORTANT: When working on NixOS configuration in this project, target ${NIXOS_RELEASE}.

Rules:
- Use ${NIXOS_RELEASE} option names, module behavior, and package expectations.
- Prefer stable ${NIXOS_RELEASE} semantics over unstable or newer release behavior.
- Do not suggest options, defaults, or modules that only exist in later releases unless the user explicitly asks for another release.
- If a setting may differ between releases, call that out explicitly and keep the recommendation aligned with ${NIXOS_RELEASE}.
- For nixpkgs or NixOS guidance, assume this repo should stay compatible with ${NIXOS_RELEASE} unless the user says otherwise.
`;

export default function nixosReleaseExtension(pi: ExtensionAPI) {
  pi.on("session_start", async (_event, ctx) => {
    ctx.ui.setStatus("nixos-release", `🧊 ${NIXOS_RELEASE}`);
  });

  pi.on("before_agent_start", async (event) => {
    return {
      systemPrompt: `${event.systemPrompt}\n\n${NIXOS_RELEASE_INSTRUCTIONS}`,
    };
  });

  pi.registerCommand("nixos-release", {
    description: "Show the NixOS release enforced by this project extension",
    handler: async (_args, ctx) => {
      ctx.ui.notify(`Using ${NIXOS_RELEASE} for NixOS configuration guidance`, "info");
    },
  });
}
