#!/usr/bin/env bash

set -e

source="$(dirname "$(readlink -f "$0")")"
td="$source/trebledroid"
tds="$source/trebledroid-staging"
personal="$source/personal"

apply_patches() {
    local path_dir="$1"
    local label="${path_dir##*/}"
    label="${label^^}"

    if [ -e "$path_dir" ]; then
        printf "\n##### APPLYING ${label} PATCHES #####\n"

        shopt -s nullglob
        for path in "$path_dir"/*; do
            name="$(basename "$path")"
            tree="$(tr _ / <<< "$name" | sed -e 's;platform/;;g')"
            printf "\n| $name #####\n"

            case "$tree" in
                build) tree=build/make ;;
                vendor/hardware/overlay) tree=vendor/hardware_overlay ;;
                treble/app) tree=treble_app ;;
                frameworks/base/new) tree=frameworks/base ;;
            esac

            pushd "$tree" >/dev/null
            git clean -fdx
            git reset --hard

            for patch in "$path/"*.patch; do
                if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
                    git am "$patch" || { git am --abort; exit 1; }
                else
                    patch -p1 --no-backup-if-mismatch < "$patch" || exit 1
                fi
            done

            popd >/dev/null
        done
    else
        printf "\n##### NO ${label} PATCHES #####\n"
    fi
}

apply_patches "$td"
apply_patches "$tds"
apply_patches "$personal"
