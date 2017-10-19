# Script to download and compile GNUPG from source

This script allows you install gpg locally in your
home directory.

It is useful in case you don't want to use a
packaging system or you need a newer version.

Simply run

  	curl https://raw.githubusercontent.com/galanakis/GPG-Install-from-Source/master/gpg_install.sh | sh

Everything is installed at 

	$HOME/.gnupg/system

You may want to add
	
	$HOME/.gnupg/system/bin

to the path or create an alias

	alias gpg=$HOME/.gnupg/system/bin/gpg

The script is a bit basic and compiles gpg with
the minimum feature set. If there is interest I
may update it.

It was tested on MacOS.
