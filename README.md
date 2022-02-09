Configuration for nixos and home-manager.

# Intsall on a new computer

* Set up networking https://nixos.org/manual/nixos/stable/index.html#sec-installation-booting-networking
* Clone this repo
* Paritioning
  * run `zfs-setup.sh <disk>`
  * move clone into `/mnt/persist`
* run `nixos-generate-config --root /mnt` and check
* run `nixos-install`
* set root password
* reboot into basic system
* ... TBD (some variation on the `Old setup instructions` below)

Old setup instructions
-----
```
$ ln -s /path/to/clone/ etc/nixos
$ nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
$ nix-channel --update
$ nixos-rebuild switch
```

sops notes
----
copy sops age key to `~/.config/sops/age/keys.txt`

`nix shell nixpkgs#age -c age-keygen -y ~/.config/sops/age/keys.keys.txt`
`cat /persist/etc/ssh/ssh_host_ed25519_key.pub | nix run nixpkgs#ssh-to-age`
add output of ^ to `.sops.yaml` as `m_<hostname>`
`nix run nixpkgs#sops -- updatekeys modules/sops/secrets.yaml`
