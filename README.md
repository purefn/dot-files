Configuration for nixos and home-manager.

Setup
-----
```
$ ln /path/to/clone/nixos /etc/nixos
$ nixos-rebuild switch
$ ln /path/to/clone/home ~/.config/nixpkgs
$ nix-channel --add https://github.com/rycee/home-manager/archive/master.tar.gz home-manager
$ nix-channel --update
$ nix-shell '<home-manager>' -A install
```

TODO
----
* Switch to using home-manager as a NixOS module
