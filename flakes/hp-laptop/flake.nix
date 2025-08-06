{
  description = "Flake for HP Laptop";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };
  
  # nixpkgs will be most used other inputs need too be manualy defined
  outputs = { nixpkgs, ... } @ inputs: 
    let
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in
  {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem { 
        modules = [
            ./configuration.nix
        ];
    };
  };
}
