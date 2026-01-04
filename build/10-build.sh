#!/usr/bin/bash

set -eoux pipefail

###############################################################################
# Build Orchestrator Script
###############################################################################
# This script orchestrates the execution of all build scripts in sequence.
# It replaces multiple RUN commands in the Containerfile with a single
# entry point, reducing image layers and consolidating mount configurations.
###############################################################################

echo "::group:: Starting Build Process"
echo "Orchestrating build scripts..."
echo "::endgroup::"

# Execute build scripts in sequence
# Each script is checked for existence before execution
for script in 15-custom-files.sh 20-packages.sh 30-workarounds.sh 40-systemd.sh 90-cleanup.sh; do
    script_path="/ctx/build/${script}"
    if [[ ! -x "${script_path}" ]]; then
        echo "ERROR: Build script ${script} not found or not executable" >&2
        exit 1
    fi
    echo "::group:: Executing ${script}"
    "${script_path}"
    echo "::endgroup::"
done

echo "All build scripts completed successfully!"
