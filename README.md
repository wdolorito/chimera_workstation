This file needs ham.

* describe installataion
* Chimera linux
* no grub?
* labwc menus

# ssh-agent shenanigans

On previous non-DE distro setups (debian, devuan, void) in other repos, a nice thing was to store ssh keys in a keychain (gnome-keyring) so they could be unlocked after login.  Let's do something different and ditch an extra package.

The nice thing is that ```ssh-agent``` is included in the openssh package and some hoops can be jumped through to share it between all open shells.  Running ```ssh-agent``` will create a socket, and spit out the socket location and the PID of that running agent.  We don't need all that mess.

The trick is to specify a socket location when starting ```ssh-agent``` and exporting this value to subshells.  This is all handled by the script ```add_ssh_keys``` which needs to live in ~/.ssh/.  Two important environment variables are set in ```.zshrc``` and ```.shrc```, SSH_AUTH_SOCK and SSH_ASKPASS_REQUIRE.  The former should, hopefully, be self explanatory.  The latter is needed so that whichever terminal is open will receive the passphrase prompt.

The helper script lives in ~/.ssh/ so that the flatpak version of codium can be able to see it from its built-in shell.  Be sure to enable ```filesystem=home``` and ```socket=ssh-auth``` using Flatseal.

Added keys will be removed after a timeout of 4 hours.  This value can be changed in ```add_ssh_keys``` (TIMEOUT="<timeout>").  The annoyance of this setup is that the passphrase of the key, if set, will be prompted for every <timeout>.  The AddKeysToAgent option does make it less annoying, especially when codium throws a fit right when the 'Sync Changes' button fails because the key has fallen out.  Close and then reopen the built-in shell, put in the passphrase in the codium prompt, or start up one in labwc to refresh them, and it's good to go.

# flatpak setup

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