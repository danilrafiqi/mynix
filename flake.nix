{
  description = "Multi-platform Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      # Helper to create homeConfigurations
      mkHomeConfig = system: username: isWSL: home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        extraSpecialArgs = { inherit isWSL; };
        modules = [ ./home.nix ];
      };
    in
    {
      # 1. Apple Silicon Mac
      homeConfigurations."mdanilrafiqi" = mkHomeConfig "aarch64-darwin" "mdanilrafiqi" false;

      # 2. Native Linux (Ubuntu/Fedora/DLL) - Dengan Aplikasi GUI
      homeConfigurations."mdanilrafiqi-linux" = mkHomeConfig "x86_64-linux" "mdanilrafiqi" false;

      # 3. Windows WSL - Tanpa Aplikasi GUI (Gunakan Native Windows)
      homeConfigurations."mdanilrafiqi-wsl" = mkHomeConfig "x86_64-linux" "mdanilrafiqi" true;
    };
}
