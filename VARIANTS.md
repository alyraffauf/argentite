# Kyanite Variants

Kyanite comes in two flavors, both built from the same Containerfile using the `IMAGE_FLAVOR` build argument.

## Available Variants

### kyanite (main)
**Image**: `ghcr.io/alyraffauf/kyanite:stable`

Clean KDE Plasma desktop for general use. No gaming tools pre-installed.

### kyanite-gaming
**Image**: `ghcr.io/alyraffauf/kyanite-gaming:stable`

Gaming-focused variant with Steam and gaming tools baked in:
- Steam (native package)
- gamescope (compositor for gaming)
- gamemode (performance optimization)
- MangoHud (performance overlay, x86_64 and i686)

## Switching Between Variants

```bash
# Switch to standard kyanite
sudo bootc switch ghcr.io/alyraffauf/kyanite:stable
sudo systemctl reboot

# Switch to gaming variant
sudo bootc switch ghcr.io/alyraffauf/kyanite-gaming:stable
sudo systemctl reboot
```

## Building Locally

### Standard Kyanite
```bash
just build
# or explicitly:
just build kyanite stable main
```

### Gaming Variant
```bash
IMAGE_FLAVOR=gaming just build
# or explicitly:
just build kyanite stable gaming
```

### Build VM Images
```bash
# Standard
just build-qcow2

# Gaming
IMAGE_FLAVOR=gaming just build-qcow2
```
