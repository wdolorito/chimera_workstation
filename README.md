This file needs ham.

* describe installataion
* Chimera linux
* no grub?
* labwc menus

# Flatpak setup

Set up the following repos:

```
flatpak --user remote-add --if-not-exists flathub https://dl.flathub.org/repo

flatpak --user remote-add --if-not-exists flathub-beta https://flathub.org/beta-repo/flathub-beta.flatpakrepo
```

Run in toplevel of repo to add some default apps:

```
for app in $(cat flatpak_apps.txt) ; do flatpak install flathub -y --noninteractive "$app" ; done
```

This command isn't fully non-interactive. If a prompt shows up for an Extension , match the version of the previously installed Extensions.  If Xwayland running is an annoyance, a version installed from flathub-beta might have wayland support.  Installed default apps listed in repo should all be wayland native.

Use language extensions for codium:

```
flatpak --user --override --environment="FLATPAK_ENABLE_SDK_EXT=llvm,node22,openjdk21"
```

Additional applications with descriptions can be found here:

https://flathub.org/

or, search for useful apps using the command line:

```
flatpak search <app>
```