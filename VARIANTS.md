# Kyanite Variants

Kyanite comes in two flavors, both built from the same Containerfile using the `IMAGE_FLAVOR` build argument.

## Available Variants

### kyanite (main)
**Image**: `ghcr.io/alyraffauf/kyanite:stable`

Clean KDE Plasma desktop for general use. No gaming tools pre-installed.

### kyanite-gaming
**Image**: `ghcr.io/alyraffauf/kyanite-gaming:stable`

Gaming-focused variant with Steam and gaming tools baked in:
- Steam (native package from negativo17)
- steam-devices (controller/peripheral support)
- gamescope, gamemode
- MangoHud, vkBasalt
- Vulkan tools and drivers

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

## How It Works

The variant system uses a single Containerfile with conditional logic:

1. **Build argument**: `IMAGE_FLAVOR` (default: "main")
2. **Build script**: `build/20-packages.sh` checks `IMAGE_FLAVOR`
3. **If gaming**: Installs Steam and gaming stack
4. **If main**: Skips gaming installation

### GitHub Actions

The build system uses a reusable workflow for maximum code reuse:

**Reusable Workflow**: `.github/workflows/build-image.yml`
- Contains all build logic
- Accepts inputs: `image_name`, `image_flavor`, `image_desc`, `image_keywords`
- Used by both variant workflows

**Variant Workflows**:
- `.github/workflows/build.yml` → calls reusable workflow with `image_flavor: main`
- `.github/workflows/build-gaming.yml` → calls reusable workflow with `image_flavor: gaming`

Both run on every push to main. All build logic is centralized in the reusable workflow.

## Why Native Steam?

The gaming variant uses **native RPM Steam** (not Flatpak) because:

- ✅ Full filesystem access (no permission issues)
- ✅ Maximum game compatibility
- ✅ Better modding tool integration
- ✅ No path length restrictions
- ✅ Same approach as Bazzite (proven at scale)

Common Flatpak Steam issues we avoid:
- Library folder access problems
- Path too long errors
- AppImage games not running
- Missing 32-bit dependencies
- Anti-cheat compatibility

## Checking Your Variant

```bash
# Check variant metadata (gaming only)
cat /etc/kyanite/variant

# Check if Steam is installed
rpm -q steam

# List installed image
bootc status
```

## Size Comparison

| Variant | Approximate Size |
|---------|------------------|
| kyanite | ~2.5 GB |
| kyanite-gaming | ~3.0 GB |

## References

- [Bazzite Steam Installation](https://github.com/ublue-os/bazzite/blob/main/Containerfile)
- [negativo17 Steam Repository](https://negativo17.org/steam/)
- [steam-devices Package](https://github.com/ValveSoftware/steam-devices)
