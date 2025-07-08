{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "git+file:///shed/Projects/nixer/!core/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    { nixpkgs, home-manager, ... }:
    let
      myLib = {
        mine = { };
      };
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
      };

      lib = pkgs.lib.extend (_: _: home-manager.lib // myLib);
    in
    {
      homeConfigurations.jdoe = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          (
            { lib, ... }:
            {
              home.username = builtins.trace "i mine=${toString (lib ? mine)}, hm=${toString (lib ? hm)}" "jdoe";
              home.homeDirectory = "/home/jdoe";
              home.stateVersion = "25.05";
            }
          )
        ];
        extraSpecialArgs = {
          inherit lib;
        };
      };
      inherit lib;
    };
}
