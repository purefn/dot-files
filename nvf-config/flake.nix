{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nvf = {
      # url = "github:purefn/nvf/haskell-tools-optional-cmd";
      url = "github:NotAShelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs@{ self, nixpkgs, nvf, ... }: {
    homeManagerModules = { 
      nvf = inputs.nvf.homeManagerModules.default;
      nvf-config = {
        programs.nvf = {
          enable = true;
          settings = import ./configuration.nix;
        };
      };
      default = {
        imports = [
          self.homeManagerModules.nvf
          self.homeManagerModules.nvf-config
        ];
      };
    };
    packages.aarch64-darwin.default = 
      let 
        nvf = inputs.nvf.lib.neovimConfiguration {
          pkgs = nixpkgs.legacyPackages.aarch64-darwin;
          modules = [ (import ./configuration.nix) ];
        };
      in nvf.neovim;
  };
}
