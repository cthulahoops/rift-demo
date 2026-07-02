# Rift demo project — a minimal repository configured for Rift devboxes.
#
# Rift's managed builder clones this repo on push and runs a pure
# `nix build .#devimage`. Everything a devbox image needs is defined right
# here: import the published `rift` flake, call `lib.mkDevimage`, and expose
# the result as `packages.x86_64-linux.devimage`.
#
# See https://github.com/fixed-labs/oss/blob/main/docs/image-config.md for
# the full walkthrough.
{
  description = "Rift demo project";

  inputs.rift.url = "github:fixed-labs/oss";

  outputs =
    { self, rift, ... }:
    {
      # Managed builds build exactly this attribute.
      packages.x86_64-linux.devimage = rift.lib.mkDevimage {
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

        # Bake this repo's source into the image so it's waiting in the box's
        # home directory at boot. Under the pure managed build, `self` is the
        # correct handle to the checked-out tree.
        repoSrc = self;
        imageCommit = self.rev or null;
      };
    };
}
