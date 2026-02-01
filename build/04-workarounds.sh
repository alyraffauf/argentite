#!/usr/bin/env bash

set -eoux pipefail

###############################################################################
# System Workarounds
###############################################################################
# This script applies workarounds for known issues and compatibility fixes.
###############################################################################

echo "::group:: Apply System Workarounds"

# Fix /nix directory for Nix package manager compatibility on Fedora >=42
mkdir -p /nix
chown root:root /nix
chmod 755 /nix

glib-compile-schemas /usr/share/glib-2.0/schemas

echo "::endgroup::"

echo "System workarounds applied successfully!"
