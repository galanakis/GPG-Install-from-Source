#! /bin/sh





#+---------------------------------+
#  Dependency tree                 |
#                                  |
#                                  |
#                     ncurses      |
#                       ^          |
#                       |          |
#                       +          |
#     libassuan<------+pinentry    |
#       ^               +          |
#       |               |          |
#    +--+---+           v          |
# +--+gnupg|-->ksba+-->libgpg+error|
# |  +--+---+    ^      ^          |
# |     |        |      |          |
# |     v        |      |          |
# +-->ntbtls+----+------+          |
# |     +               |          |
# |     |               |          |
# |     v               |          |
# +-->libgcrypt+--------+          |
# |     +                          |
# |     |                          |
# |     v                          |
# +-->nth                          |
#----------------------------------+


# VERSIONS
VER_GPG=2.2.1
VER_LIBGPG_ERROR=1.27
VER_LIBGCRYPT=1.8.1
VER_LIBKSBA=1.3.5
VER_LIBASSUAN=2.4.3
VER_NTBTLS=0.1.2
VER_NPTH=1.5
VER_PINENTRY=1.0.0
VER_NCURSES=6.0

# Installation directory
export PREFIX=$HOME/.gnupg/system

# Creating the .gnupg directory under the user's home
# The permissions should be 700
echo "Will install under $PREFIX directory"
[ -d $PREFIX ] || (mkdir -p -m 700 $PREFIX && chmod 700 $HOME/.gnupg)

# Downloading the files
curl https://gnupg.org/ftp/gcrypt/gnupg/gnupg-$VER_GPG.tar.bz2 | tar xz
curl https://gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-$VER_LIBGPG_ERROR.tar.bz2 | tar xz
curl https://gnupg.org/ftp/gcrypt/libgcrypt/libgcrypt-$VER_LIBGCRYPT.tar.bz2 | tar xz
curl https://gnupg.org/ftp/gcrypt/libksba/libksba-$VER_LIBKSBA.tar.bz2 | tar xz
curl https://gnupg.org/ftp/gcrypt/libassuan/libassuan-$VER_LIBASSUAN.tar.bz2 | tar xz
curl https://gnupg.org/ftp/gcrypt/ntbtls/ntbtls-$VER_NTBTLS.tar.bz2 | tar xz
curl https://gnupg.org/ftp/gcrypt/npth/npth-$VER_NPTH.tar.bz2 | tar xz
curl https://gnupg.org/ftp/gcrypt/pinentry/pinentry-$VER_PINENTRY.tar.bz2 | tar xz
curl https://ftp.gnu.org/pub/gnu/ncurses/ncurses-$VER_NCURSES.tar.gz | tar xz

echo "Compiling libgpg-error"
(cd libgpg-error-$VER_LIBGPG_ERROR && ./configure --prefix=$PREFIX && make && make install)

echo "Compiling npth"
(cd npth-$VER_NPTH && ./configure --prefix=$PREFIX && make && make install)

echo "Compiling libassuan"
(cd libassuan-$VER_LIBASSUAN && ./configure --prefix=$PREFIX --with-libgpg-error-prefix=$PREFIX && make && make install)

echo "Compiling libksba"
(cd libksba-$VER_LIBKSBA && ./configure --prefix=$PREFIX --with-libgpg-error-prefix=$PREFIX && make && make install)

echo "Compiling libgcrypt"
(cd libgcrypt-$VER_LIBGCRYPT && ./configure --prefix=$PREFIX --with-libgpg-error-prefix=$PREFIX --with-pth-prefix=$PREFIX && make && make install)

echo "Compiling ntbtls"
(cd ntbtls-$VER_NTBTLS && ./configure --prefix=$PREFIX --with-libgpg-error-prefix=$PREFIX --with-libgcrypt-prefix=$PREFIX --with-ksba-prefix=$PREFIX && make && make install)

echo "Compiling ncurses"
(cd ncurses-$VER_NCURSES && ./configure --prefix=$PREFIX && make && make install)

echo "Compiling pinentry"
(cd pinentry-$VER_PINENTRY && ./configure --prefix=$PREFIX --with-libgpg-error-prefix=$PREFIX --with-libassuan-prefix=$PREFIX --with-ncurses-include-dir=$PREFIX/include && make && make install)

echo "Compiling gnupg"
(cd gnupg-$VER_GPG && ./configure --prefix=$PREFIX --with-libgpg-error-prefix=$PREFIX --with-libgcrypt-prefix=$PREFIX --with-ksba-prefix=$PREFIX --with-npth-prefix=$PREFIX --with-libassuan-prefix=$PREFIX --with-ntbtls-prefix=$PREFIX && make && make install)

echo "Deleting temporary files"
rm -rf libgpg-error-$VER_LIBGPG_ERROR
rm -rf npth-$VER_NPTH
rm -rf libassuan-$VER_LIBASSUAN
rm -rf libksba-$VER_LIBKSBA
rm -rf libgcrypt-$VER_LIBGCRYPT
rm -rf ntbtls-$VER_NTBTLS
rm -rf gnupg-$VER_GPG
rm -rf ncurses-$VER_NCURSES
rm -rf pinentry-$VER_PINENTRY

# Run the gpg program to create a key
cat << EOF
+-------------------------------------------------+
|-------------------------------------------------|
|| The installation was completed successfully.  ||
|-------------------------------------------------|
|| The following directory needs to be added to  ||
|| the path:                                     ||
||                                               ||
||  '$HOME/.gnupg/system/bin'                    ||
||                                               ||
|| You can start by generating a key by in^oking ||
||                                               ||
||  '$HOME/.gnupg/system/bin/gpg --gen-key'      ||
||                                               ||
|| After you generated the key you can encrypt   ||
|| a file                                        ||
||                                               ||
||  '$HOME/.gnupg/system/bin/gpg -e secrets.txt' ||
||                                               ||
|| which will save the encrypted contents in     ||
|| secrets.txt.gpg                               ||
||                                               ||
|| You can decrypt this file by invoking         ||
||                                               ||
|| gpg -d secrets.txt.gpg                        ||
||                                               ||
|| Enjoy!                                        ||
|-------------------------------------------------|
+-------------------------------------------------+

EOF




