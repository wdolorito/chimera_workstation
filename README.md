# dot files and support scripts for a labwc Chimera linux installation

https://chimera-linux.org

Why Chimera Linux?  There's a pitch in the above website.  Personally, it's interesting to mess with something that's not bash ***OR*** d/ash.  Also, musl + libc++.  The journey for these files in this repo was a good one, revising previously used config files and attaining more understanding of what and why files are placed where they are and the meaning of values in config files.  Not to mention different conventions from the unfamiliar userland.  It doesn't matter which one is ***better***, just that it gets out of the way when work needs to be done.  Being aware of the differences makes it easier/faster to figure out where and what has broken (in userland) that affects doing business in a shell.

Speaking of shells, one of the strangest yet familiar interfaces was switching to a BSD ```sh``` (specifically FreeBSD) from ```bash```.  It is fascinating that scripts written on one system have a more than zero probability of not running on a second system because the default installed shell is different than ```bash```.  That symbolic linking of ```sh``` to ```bash``` on a majority of linux distributions makes it *seem* that a script will be shareable with a buddy until it doesn't produce expected output on their system.  Enter ```shellcheck``` (https://www.shellcheck.net/) in to the chat.

While running things through ```shellcheck``` (Grab a binary from them if serious about posix shell scripting.  Seriously.) can help a lot with this portability issue, it doesn't save a user from scripts written for other shells (```fish``` and ```tcsh``` anyone?).  This is why it was fun spending tech debt revising the support scripts and implementing the suggestions offered by ```shellcheck```.  Having the default shell be a legitimate ```sh``` helped the process immensely.

That said, another shell is also installed if following directions in this repo, ```zsh```.  Switch to it using the ```chsh``` command.  This one is entirely because it became the default shell on macOS.  It does have one really nice feature, a two line prompt.  After spending a lot of time in that shell and OS for a day job, it was an easy copy pasta of config files used there to this installation.  And the question of why ```screen``` instead of ```tmux```?  GNU ```screen``` was also a default included utility in macOS.

Another conscious choice was the use of ```flatpak``` and Flathub (https://flathub.org) for user applications.  This one utility was a boon, especially for debian (still a number one choice) where having the latest version of a distro supported application leaves a lot to be desired.  It provides consistency across different linux distributions, since the applications are sandboxed and self contained.  This entire repo was put together and committed (mostly) with the VSCodium flatpak.  Not having to install distro supported build tools for dev is nice, but having only one integrated shell open at any one time is a little annoying.  Don't like the default browser choice of Floorp?  Install the real Firefox or (meh) Chrome from Flathub (```flatpak install firefox``` *or* ```flatpak install chrome```)

The other major choice was window manager.  While living in a console is super nerd and very appealing, ain't no way is ```emacs``` and ```vim``` a full desktop computing experience, no offense to those that go that route.  The choice was labwc (https://labwc.github.io/).  This differs from the preferences for debian (swaywm), devuan (wayfire) and void (rolling preference of swaywm, wayfire, labwc).  The commonality is the use of wayland.  And let's be honest, no typical user spends the majority of their time in a GUI-less operating system.  Try making a workflow using ```netsurf-fb```, ```mpv``` and ```fbi``` from a framebuffer console (if it's even avaialble).  Reading/editing a ```docx``` file or any common office file?  Doable, but good luck not getting lost in pipeland.  In general, the experience is at worst painful and at best inconvenient.

One final note about these installation instructions, the sharp eyed will notice there is no bootloader installed (grub, refind, uboot, syslinux, \<insert favorite bootloader here\>).  This is because the particular installation these instructions are based on share space with another linux distribution (debian) that controls booting.  Adding this is easy with a simple ```apk add grub```.

The next question from that might perhaps be why isn't this installation the primary or only distribution on that system?  There is one utility not included because it doesn't seem to exist, ```lxc```, one of the reasons (among many) the use of debian has always been first choice for installations.  Why not something like ```docker``` or maybe ```qemu``` + ```virt-manager```?  The short story is, people like what they're comfortable with.  The partial long answer are personal biases against ```docker``` (what an lxc copy!) and the overhead of adding additional dependcies to run ```virt-manager```.  It's also easy to add these if desired.

## ssh-agent shenanigans

On previous non-DE distro setups (debian, devuan, void) in other repos, a nice thing was to store ssh keys in a keychain (gnome-keyring) so they could be unlocked after login.  Let's do something different and ditch a few extra packages.

The cool thing is that ```ssh-agent``` is included in the openssh package and some hoops can be jumped through to share it between all open shells.  Running ```ssh-agent``` will create a socket, and spit out the socket location and the PID of that running agent.  We don't need all that mess.

The trick is to specify a socket location when starting ```ssh-agent``` and exporting this value to subshells.  This is all handled by the script ```add_ssh_keys``` which needs to live in ~/.ssh/.  Two important environment variables are set in ```~/.zshrc``` and ```~/.shrc```, SSH_AUTH_SOCK and SSH_ASKPASS_REQUIRE.  The former should, hopefully, be self explanatory.  The latter is needed so that whichever terminal is open will receive the passphrase prompt.

The helper script lives in ~/.ssh/ so that the flatpak version of codium can be able to see it from its built-in shell.  Be sure to enable ```filesystem=home``` and ```socket=ssh-auth``` using Flatseal.

Added keys will be removed after a timeout of 4 hours.  This value can be changed in ```add_ssh_keys``` (TIMEOUT="\<timeout\>").  The annoyance of this setup is that the passphrase of the key, if set, will be prompted every \<timeout\>.  The AddKeysToAgent option does make it less annoying, especially when codium throws a fit right when the 'Sync Changes' button fails because the key has fallen out.  Close and then reopen the built-in shell, put in the passphrase in the codium prompt, or start up a terminal in labwc to refresh them, and it's good to go.

## flatpak setup

Set up the following repos:

```
flatpak --user remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

flatpak --user remote-add --if-not-exists flathub-beta https://flathub.org/beta-repo/flathub-beta.flatpakrepo
```

Run in toplevel of repo to add a few useful default apps:

```
for app in $(cat flatpak_apps.txt) ; do flatpak install flathub -y --noninteractive "$app" ; done
```

This command isn't fully non-interactive. If a prompt shows up for an Extension , match the version of the previously installed Extensions.  If Xwayland running is an annoyance, a version installed from flathub-beta might have wayland support (GIMP 3.0 was only available there for a time).  Installed default apps listed in repo should all be wayland native.

Use language extensions for codium:

```
flatpak --user override --env="FLATPAK_ENABLE_SDK_EXT=llvm20,node22,openjdk21" com.vscodium.codium
```

Additional applications with descriptions can be found here:

https://flathub.org/

or, search for useful apps using the command line:

```
flatpak search <app>
```

## jewels (?)

The heavy lifting of this particular repo is done by the Chimera Linux team (https://chimera-linux.org).  All credit due to that group of folks supporting an amazing project.  Aside from the trivial config files for distro supplied applications, the "contribution" of this repo to the public at large could be the shell based ```create_labwc_menus``` script.  Written over the course of several obsession fueled days and lots of trial and error, this script will output a labwc, and through heritage, openbox, compatible ```menu.xml``` file.

A complete ```menu.xml``` file of currently installed applications can be created like so:

```
create_labwc_menu full
```

At completion of execution, the script will output the location of the created file, defined at the top of the script, the default being ```$XDG_RUNTIME_DIR/menu.xml``` (e.g. ```/run/user/1000/menu.xml```).  Just copy that file to ```~/.config/labwc/menu.xml``` and reload the configuration, and a full menu with little icons should appear on subsequent invocations.  This menu file is useful if installed applications never change.  It's also useful if installed on ancient hardware with extremely limited resources.  There's a slight savings of time during labwc startup since it doesn't have to generate the dynamic 'Programs' menu.

While time savings (compute cycles) is important for older hardware, it's less of an issue on modern hardware (newer than around 2010).  Pretty much 100% of the time, users will add and remove programs several times, rendering that fixed menu obsolete immediately afterwards especially with flatpak applications installed.  To the rescue are pipemenus!  Generate one with:

```
create_labwc_menu dynamic
```

Copy this menu in to labwc's config directory and a new option will appear in the menu, 'Reset Programs'.  Now, whenever a new flatpak or distro application is installed or removed, selecting that option will remake the 'Programs' menu to reflect that change.
