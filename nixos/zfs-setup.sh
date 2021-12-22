#!/usr/bin/env bash

#
# Prepare disk for NixOS install with ZFS.
# This is a trimmed down version https://gist.github.com/mx00s/ea2462a3fe6fdaa65692fe7ee824de3e
#
# It expects the name of the block device (e.g. 'sda') to partition.
#
# Example: `sudo ./install.sh sde `
#

set -euo pipefail

################################################################################

export COLOR_RESET="\033[0m"
export RED_BG="\033[41m"
export BLUE_BG="\033[44m"

function err {
    echo -e "${RED_BG}$1${COLOR_RESET}"
}

function info {
    echo -e "${BLUE_BG}$1${COLOR_RESET}"
}

################################################################################

export DISK=$1

if ! [[ -v DISK ]]; then
    err "Missing argument. Expected block device name, e.g. 'sda'"
    exit 1
fi

export DISK_PATH="/dev/${DISK}"

if ! [[ -b "$DISK_PATH" ]]; then
    err "Invalid argument: '${DISK_PATH}' is not a block special file"
    exit 1
fi

if [[ "$EUID" > 0 ]]; then
    err "Must run as root"
    exit 1
fi

export ZFS_POOL="rpool"

# ephemeral datasets
export ZFS_LOCAL="${ZFS_POOL}/local"
export ZFS_DS_ROOT="${ZFS_LOCAL}/root"
export ZFS_DS_NIX="${ZFS_LOCAL}/nix"

# persistent datasets
export ZFS_SAFE="${ZFS_POOL}/safe"
export ZFS_DS_HOME="${ZFS_SAFE}/home"
export ZFS_DS_PERSIST="${ZFS_SAFE}/persist"

export ZFS_BLANK_SNAPSHOT="${ZFS_DS_ROOT}@blank"

################################################################################

info "Running the UEFI (GPT) partitioning and formatting directions from the NixOS manual ..."
parted "$DISK_PATH" -- mklabel gpt
parted "$DISK_PATH" -- mkpart primary 512MiB 100%
parted "$DISK_PATH" -- mkpart ESP fat32 1MiB 512MiB
parted "$DISK_PATH" -- set 2 boot on
export DISK_PART_ROOT="${DISK_PATH}1"
export DISK_PART_BOOT="${DISK_PATH}2"

info "Formatting boot partition ..."
mkfs.fat -F 32 -n boot "$DISK_PART_BOOT"

info "Creating '$ZFS_POOL' ZFS pool for '$DISK_PART_ROOT' ..."
zpool create -f "$ZFS_POOL" "$DISK_PART_ROOT"

info "Enabling compression for '$ZFS_POOL' ZFS pool ..."
zfs set compression=on "$ZFS_POOL"

info "Creating '$ZFS_DS_ROOT' ZFS dataset ..."
zfs create -p -o mountpoint=legacy "$ZFS_DS_ROOT"

info "Configuring extended attributes setting for '$ZFS_DS_ROOT' ZFS dataset ..."
zfs set xattr=sa "$ZFS_DS_ROOT"

info "Configuring access control list setting for '$ZFS_DS_ROOT' ZFS dataset ..."
zfs set acltype=posixacl "$ZFS_DS_ROOT"

info "Creating '$ZFS_BLANK_SNAPSHOT' ZFS snapshot ..."
zfs snapshot "$ZFS_BLANK_SNAPSHOT"

info "Mounting '$ZFS_DS_ROOT' to /mnt ..."
mount -t zfs "$ZFS_DS_ROOT" /mnt

info "Mounting '$DISK_PART_BOOT' to /mnt/boot ..."
mkdir /mnt/boot
mount -t vfat "$DISK_PART_BOOT" /mnt/boot

info "Creating '$ZFS_DS_NIX' ZFS dataset ..."
zfs create -p -o mountpoint=legacy "$ZFS_DS_NIX"

info "Disabling access time setting for '$ZFS_DS_NIX' ZFS dataset ..."
zfs set atime=off "$ZFS_DS_NIX"

info "Mounting '$ZFS_DS_NIX' to /mnt/nix ..."
mkdir /mnt/nix
mount -t zfs "$ZFS_DS_NIX" /mnt/nix

info "Creating '$ZFS_DS_HOME' ZFS dataset ..."
zfs create -p -o mountpoint=legacy "$ZFS_DS_HOME"

info "Mounting '$ZFS_DS_HOME' to /mnt/home ..."
mkdir /mnt/home
mount -t zfs "$ZFS_DS_HOME" /mnt/home

info "Creating '$ZFS_DS_PERSIST' ZFS dataset ..."
zfs create -p -o mountpoint=legacy "$ZFS_DS_PERSIST"

info "Mounting '$ZFS_DS_PERSIST' to /mnt/persist ..."
mkdir /mnt/persist
mount -t zfs "$ZFS_DS_PERSIST" /mnt/persist

info "Permit ZFS auto-snapshots on ${ZFS_SAFE}/* datasets ..."
zfs set com.sun:auto-snapshot=true "$ZFS_DS_HOME"
zfs set com.sun:auto-snapshot=true "$ZFS_DS_PERSIST"

info "Ready to complete installation."



