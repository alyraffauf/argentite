# Argentite

Argentite is a custom bootable container based on Fedora Silverblue focusing on minimal branding, sane defaults, and clean behavior. Built with [Universal Blue](https://universal-blue.org/).

![](./_img/screenshot.png)

## What Changed

Argentite is built on Universal Blue's [silverblue-main](https://github.com/ublue-os/main) image, which itself derives from Fedora Silverblue.

Argentite improves Fedora Silverblue with:

- **Saner defaults** - Mozilla's official Flatpak build of Firefox, Flathub out of the box, and modernized GNOME settings.
- **Full container workflows** - Docker CE with buildx/compose, enhanced Podman.
- **Developer tools** - Fish shell, modern terminal, comprehensive tooling.
- **Nice to haves** - Tailscale VPN, Syncthing, dynamic wallpapers.
- **Gaming necessities** - Steam, Gamescope, MangoHud, etc.
- **Audio enhancements** - Improved audio DSPs for select hardware.
- **Flexible variants** - Declarative variants you can mix and match.

## Available Variants

All images are built and published automatically:

- **argentite** - Clean, modern, featureful GNOME desktop for normal people.
- **argentite-dx** - Developer experience with Docker CE, QEMU/KVM, ROCm, Android tools, Flatpak builder, etc.
- **argentite-gaming** - Gaming experience with Steam, Gamescope, ProtonUp-Qt, Heroic Game Launcher, etc.
- **argentite-dx-gaming** - Everything combined.

## State of the Project

Argentite is quite usable as-is, and it's my daily driver. However, it's still under active development with frequent changes. Also, while the word-branding of the distribution has been changed, Fedora defaults persist in many places (`fastfetch`, wallpapers). I'm a photographer at best, not a graphics designer.

## Quick Start

If you're already on a bootc-based system (like Silverblue or Aurora), switching is easy:

```bash
# Standard variant
sudo bootc switch ghcr.io/alyraffauf/argentite:stable
sudo systemctl reboot

# Developer variant
sudo bootc switch ghcr.io/alyraffauf/argentite-dx:stable
sudo systemctl reboot

# Gaming variant
sudo bootc switch ghcr.io/alyraffauf/argentite-gaming:stable
sudo systemctl reboot

# Combined DX + Gaming
sudo bootc switch ghcr.io/alyraffauf/argentite-dx-gaming:stable
sudo systemctl reboot
```

Please be advised that some defaults in `/etc/skel` will not be copied over automatically and may need to be manually migrated. Also, rebasing across desktop environments (e.g., GNOME to KDE) is not recommended unless you know what you're doing.

After first boot, explore available commands:

```bash
ujust --list
```

## Customization

Argentite uses a declarative configuration system:

- **[packages.json](packages.json)** - Define packages per variant.
- **[services.json](services.json)** - Configure systemd units by variant.
- **files/{variant}/** - Variant-specific system files (main, gaming, dx).
- **[brew/](brew/)** - Homebrew packages (runtime installation).
- **[flatpaks/](flatpaks/)** - Flatpak preinstall files by variant.
- **[ujust/](ujust/)** - Custom `ujust` commands by variant.

Stacking variants are composed at build time. It is trivial to fork this repository and create your own Argentite variants. See below for build options.

## Building Locally

Requires [Podman](https://podman.io/) and [Just](https://just.systems/):

```bash
# Build standard variant
just build

# Build specific variant
IMAGE_FLAVOR=dx just build
IMAGE_FLAVOR=gaming just build
IMAGE_FLAVOR=dx-gaming just build

# Build with NVIDIA base image
BASE_IMAGE_SHA=$(skopeo inspect docker://ghcr.io/ublue-os/silverblue-nvidia:latest --format '{{.Digest}}')
BASE_IMAGE=ghcr.io/ublue-os/silverblue-nvidia:latest \
BASE_IMAGE_SHA=$BASE_IMAGE_SHA \
IMAGE_FLAVOR=dx-gaming \
just build

# Create bootable images
just build-iso
just build-qcow2
just build-raw
```

Output appears in `output/` directory.

## Building Your Own ISO

While the build system supports ISO generation (`just build-iso`), I don't yet provide pre-built ISOs for download. Your best bet is to install Fedora Silverblue and rebase from there. However, if you'd like to skip the middleman, you may buid an install ISO locally:

```bash
just build-iso  # Requires ~10GB disk space and 30+ minutes
```

The generated ISO will be in the `output/` directory.

## Security

Images are signed with [Sigstore Cosign](https://github.com/sigstore/cosign) using keyless signing:

```bash
cosign verify \
  --certificate-identity-regexp="https://github.com/alyraffauf/argentite/.*" \
  --certificate-oidc-issuer=https://token.actions.githubusercontent.com \
  ghcr.io/alyraffauf/argentite:stable
```

### Use Signed Transport

```bash
# Switch to signed registry
sudo rpm-ostree rebase ostree-image-signed:docker://ghcr.io/alyraffauf/argentite:stable
sudo systemctl reboot

# Verify
rpm-ostree status  # Should show "ostree-image-signed:" prefix
```

## Resources

- [Universal Blue](https://universal-blue.org/) - Project ecosystem.
- [bootc Documentation](https://containers.github.io/bootc/) - Cloud-native OS.
- [Universal Blue Discord](https://discord.gg/WEu6BdFEtp) - Community support.

## License

Apache License 2.0 - See [LICENSE.md](LICENSE.md) for details.

Built with [Universal Blue](https://universal-blue.org/) tooling. Based on [Fedora Silverblue](https://fedoraproject.org/silverblue/) with [GNOME](https://gnome.org/).
