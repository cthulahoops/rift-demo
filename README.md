# Rift demo

The smallest repository that works with [Rift](https://github.com/fixed-labs/oss):
a `flake.nix` that defines a custom devbox image, and nothing else.

## What this demonstrates

Connecting a GitHub repository to Rift gets you a cloud devbox that boots an
image built **from this repo's own flake**. The whole integration is one file:

- [`flake.nix`](flake.nix) imports the published
  [`github:fixed-labs/oss`](https://github.com/fixed-labs/oss) flake, layers a
  few tools on top of the base image with `lib.mkDevimage`, and exposes the
  result as `packages.x86_64-linux.devimage` — the single attribute Rift's
  managed builder builds on every push.

There is no CI pipeline to copy and no image registry to configure. Push, and
the service builds and registers the image for you.

## Try it

1. Install the `rift` CLI — see
   [getting started](https://github.com/fixed-labs/oss/blob/main/docs/getting-started.md).
2. Connect this repository (or your fork) to Rift so the managed builder can
   see it, and wait for the image build to go green.
3. From a checkout of this repo:

   ```sh
   rift login
   rift new        # spawn a devbox for this repo
   rift connect    # open a shell inside it
   ```

Inside the box you'll find this repo's source waiting in the home directory
(baked in via `repoSrc = self`), with `go`, `rg`, and `jq` on the PATH — the
customizations `flake.nix` added.

## Make it yours

Edit the module inside `extraModules` in [`flake.nix`](flake.nix): add
packages, dotfiles, services — anything NixOS can express. Push, and the next
`rift new` boots your image. The base module's options live under the
`rift.devboxes-base` namespace; see
[image-config.md](https://github.com/fixed-labs/oss/blob/main/docs/image-config.md).
