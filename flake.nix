# Rift demo project — a minimal repository configured for Rift devboxes.
#
# Rift's managed builder clones this repo on push and runs a pure
# `nix build .#fixed-labs.rift.image`. Everything a devbox image needs is
# defined right here: import the published `rift` flake, call `lib.mkRift`,
# and expose the result as the versioned `fixed-labs.rift` contract.
#
# See https://github.com/fixed-labs/oss/blob/main/docs/image-config.md for
# the full walkthrough.
{
  description = "Rift demo project";

  inputs.rift.url = "github:fixed-labs/oss";

  outputs =
    { self, rift, ... }:
    {
      # Managed builds read exactly this output — the versioned `fixed-labs.rift`
      # contract ({ version; image; }). It lives at the custom top-level path
      # `fixed-labs.rift`, NOT under `packages`, so a bare `nix build` / `nix
      # flake check` leaves your repo's real artifacts alone.
      fixed-labs.rift = rift.lib.mkRift {
        # `self` is the checked-out tree. mkRift defaults repoSrc = self and
        # imageCommit = self.rev or null from it, so this repo's source is baked
        # into the image (waiting in the box's home directory at boot) without
        # restating those.
        inherit self;

        extraModules = [
          # Customization goes here: tools, editors, dotfiles, services.
          (
            { pkgs, ... }:
            {
              environment.systemPackages = [
                pkgs.go
                pkgs.ripgrep
                pkgs.jq
              ];

              # Base-module options are available under `rift.devboxes-base`:
              # rift.devboxes-base.loginUser = "dev";
            }
          )
        ];
      };
    };
}
