# USAGE:

* specify debian packages to put on filesystem before other buildpacks run
* we specify `gnupg2` because we need it for `blackbox` to work properly
* see: https://github.com/StackExchange/blackbox/issues/240

# NOTE:

* this works for Heroku16 (which is just ubuntu 16.4)
* if we upgrade ubuntu versions we will need to use a different .deb
* (but hopefully new versions will just ship w/ gpg versions >= 2.0?)
* find new versinos of `gnupg2` here: https://packages.ubuntu.com/search?keywords=gnupg2
