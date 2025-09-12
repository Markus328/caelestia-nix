{
  description = "A caelestia-dots home-manager module.";
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs";
    };
    caelestia-shell = {
      url = "github:caelestia-dots/shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    caelestia = {
      url = "github:caelestia-dots/caelestia";
      flake = false;
    };
  };
  outputs = inputs: {
    homeManagerModules.default = import ./caelestia.nix inputs;
  };
}
