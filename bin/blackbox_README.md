# About Blackbox

Blackbox is a super-nifty collection of bash scripts for placing sensitive files under secure version control.

# Attributions

* All scripts Copyright (c) 2014-2018 Stack Exchange, Inc.
* Made availble under MIT License

# How it Works

* maintains a whitelist of PGP keys to encrypt files to
* maintains a registry of encrypted files
* provides bash commands for editing, decrypting, re-encrypting, or shreding all tracked files
* allows a deploy agent to also decrypt files at build time

# Dependencies

We are using scripts cloned from:

* https://github.com/StackExchange/blackbox
* commit 906ecd0f8247016a10ca6e8426cd8445b122885d
* at Wed Mar 28 14:21:51 2018 -0400
