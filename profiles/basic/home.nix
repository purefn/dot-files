# Shared home-manager module imports for the basic profile.
# Used by both nixos/home-manager.nix and darwin/home-manager.nix.
#
# systemConfig: the system-level (NixOS/darwin) config for SOPS access, or null for standalone HM.
# extraImports: additional HM modules (e.g., desktop/laptop HM configs).
{ inputs, lib, systemConfig ? null, extraImports ? [] }:

[
  ./home-manager/bash
  ./home-manager/dev
  (import ./home-manager/ssh { inherit systemConfig; })
  inputs.nvf-config.homeManagerModules.nvf
  inputs.nvf-config.homeManagerModules.nvf-config
  inputs.direnv-instant.homeModules.direnv-instant
] ++ extraImports
