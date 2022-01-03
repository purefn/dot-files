self: super: {
  adjust-volume = self.haskellPackages.callPackage ./adjust-volume {};
  nix-ghci = self.callPackage ./nix-ghci {};
}
