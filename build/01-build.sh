#!/usr/bin/env bash

set -eoux pipefail

###############################################################################
# Main Build Script
###############################################################################
# This script follows the @ublue-os/bluefin pattern for build scripts.
# It uses set -eoux pipefail for strict error handling and debugging.
###############################################################################

echo "::group:: Copy Custom Files"

# Copy system files based on IMAGE_FLAVOR
# Split IMAGE_FLAVOR into array of variant names (e.g., "gaming-dx" -> ["gaming", "dx"])
# Always includes "main" as the base
IFS='-' read -ra FLAVOR_PARTS <<<"${IMAGE_FLAVOR}"

for variant in main "${FLAVOR_PARTS[@]}"; do
    if [[ -d "/ctx/files/${variant}" ]]; then
        echo "Copying files for: ${variant}"
        rsync -rvKl "/ctx/files/${variant}/" /
    fi
done

# Copy Brewfiles to standard location for each flavor
mkdir -p /usr/share/ublue-os/homebrew/
for variant in main "${FLAVOR_PARTS[@]}"; do
    if [[ -d "/ctx/brew/${variant}" ]]; then
        echo "Copying Brewfiles for: ${variant}"
        cp "/ctx/brew/${variant}"/*.Brewfile /usr/share/ublue-os/homebrew/ 2>/dev/null || true
    fi
done

# Consolidate Just Files for each flavor
mkdir -p /usr/share/ublue-os/just/
for variant in main "${FLAVOR_PARTS[@]}"; do
    if [[ -d "/ctx/ujust/${variant}" ]]; then
        echo "Installing ujust recipes for: ${variant}"
        find "/ctx/ujust/${variant}" -iname '*.just' -exec printf "\n\n" \; -exec cat {} \; >>/usr/share/ublue-os/just/60-custom.just
    fi
done

# Copy Flatpak preinstall files for each flavor
mkdir -p /usr/share/flatpak/preinstall.d/
for variant in main "${FLAVOR_PARTS[@]}"; do
    if [[ -f "/ctx/flatpaks/${variant}.preinstall" ]]; then
        echo "Installing Flatpak preinstall for: ${variant}"
        cp "/ctx/flatpaks/${variant}.preinstall" "/usr/share/flatpak/preinstall.d/argentite-${variant}.preinstall"
    fi
done

echo "::endgroup::"

echo "File copying and setup completed successfully!"
