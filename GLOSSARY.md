# Personal environment configuration

This repository manages system-wide and per-user environments across NixOS, Fedora, and macOS. This glossary defines the terms used to discuss and maintain those environments.

## Language

**Host**:
A physical or virtual machine on which a managed environment runs.
_Avoid_: Configuration target when referring to the machine.

**Configuration target**:
A named configuration that can be selected and applied to a system or user environment.
_Avoid_: Host when referring to the configuration; bare configuration when the distinction matters.

**Platform**:
An operating-system environment this repository supports, currently NixOS, Fedora, or macOS. Platform support does not imply that every feature is available on that platform.
_Avoid_: Architecture when referring to the operating-system environment.

**Architecture**:
The processor family a configuration supports, such as x86_64 or aarch64.
_Avoid_: Platform when referring to the processor family.

**Feature**:
A capability managed by this repository, such as cloud-drive access or the desktop environment. It may require both system-wide and per-user settings.
_Avoid_: File or module when referring to the capability itself.

**System configuration**:
The system-wide environment managed for a NixOS host. It can include home configurations.

**Home configuration**:
The per-user environment managed by this repository on NixOS, Fedora, or macOS. It does not imply management of the underlying operating system.

**Home Manager aspect**:
A named grouping of per-user settings that can be combined with other aspects to form a home configuration. The Linux aspect contains settings shared by NixOS and other Linux environments, while the NixOS and generic Linux aspects contain settings specific to those environments.
_Avoid_: Home Manager type when referring to a named grouping of settings.

**Web app**:
A named application dedicated to an online service, with a browsing session separate from the Work and Private browsers. Two web apps for the same service can have separate login sessions.
