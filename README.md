This repo contains a [nixpkgs overlay](https://nixos.org/nixpkgs/manual/#chap-overlays) that can be used to install Atlassian tools. It currently includes:

* [cloudtoken](https://extranet.atlassian.com/pages/viewpage.action?pageId=3110863330)
* [laas-cli](https://extranet.atlassian.com/display/OBSERVABILITY/LaaS+CLI)
* [micros-cli](https://extranet.atlassian.com/display/MICROS/Micros+CLI)
* stride

Most of they are built from source from private repositories, using [`fetchgitPrivate`](https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/fetchgit/private.nix) to pull the source. This means you need to follow the directions for configuring your nix-path such that nix can access these private repositories. From the docs:

| Please set your nix-path such that ssh-config-file points to a file that will allow ssh to access private repositories. The builder will not be able to see any running ssh agent sessions unless ssh-auth-sock is also set in the nix-path.
| Note that the config file and any keys it points to must be readable by the build user, which depending on your nix configuration means making it readable by the build-users-group, the user of the running nix-daemon, or the user calling the nix command which started the build. Similarly, if using an ssh agent ssh-auth-sock must point to a socket the build user can access.
| You may need StrictHostKeyChecking=no in the config file. Since ssh will refuse to use a group-readable private key, if using build-users you will likely want to use something like IdentityFile /some/directory/%u/key and have a directory for each build user accessible to that user.

See [ssh config](https://github.com/NixOS/nixpkgs/issues/4004) for an example of configuring an ssh-config-file.

As the repository is set up as an overlay, the easiest way to use it is to clone the repository to a nixpkgs overlays directory and then install

```
$ mkdir -p ~/.config/nixpkgs/overlays
$ git clone git@bitbucket.org:atlassianlabs/atlassian-nixpkgs.git ~/.config/nixpkgs/overlays/atlassian-nixpkgs
$ nix-env -iA nixos.micros-cli nixos.cloudtoken nixos.laas-cli nixos.stride
```

Notes on the packages:

* cloudtoken - pretty straight forward packaging. Best way to use it is to install it and then run

```
$ echo source ~/.nix-profile/share/cloudtoken/shell_additions/bashrc_additions >> ~/.bashrc
```

* micros-cli - `node2nix` is used to generate the nix expressions. Before it can be used, it is necessary to modify the source a bit. `node2nix` doesn't support private npm registries that require authentication. Instead, the source of private Atlassian dependencies is used. `node2nix` also doesn't have support for using `git+ssh` dependencies - at least, not very well. As a workaround, the sources for `inject-environment-into-object` and `ws` can be cloned locally, the dependency in `package.json` changed to `file:inject-environment-into-object` and `file:ws`. Then, after running `node2nix`, edit the generated `node-packages.nix` file use `fetchgitPrivate` for getting the source of those packages. Overall the process is a bit like this

```
$ cd /path/to/micros-cli
$ git clone git@bitbucket.org/atlassianlabs/inject-environment-into-object.git
$ git clone git@stash.atlassian.com:7997/micros/ws.git
$ <edit package.json to change @atlassian/inject-environment-into-object version to "file:inject-environment-into-object" and @atlassian/ws version to "file:ws">
$ node2nix
$ <edit node-packages.nix, change the src for @atlassian/inject-environment-into-object and @atlassian/ws to use fetchgitPrivate
```

