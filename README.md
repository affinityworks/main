# Affinity

Affinity.works is supporting the surge of resistance against Trump. It's coming at it in two ways. First, working with the new activist groups that have sprung up, building MVP's to solve the problems they've encountered in their organizing. Second, Affinity is enabling rapid collaboration between the grassroots and the big national networks like Indivisible & Daily Kos, to defend the institutions of democracy.

Concretely, the tool is a SaaS and has components for managing a network of groups, a crm, task management for volunteers, outreach, and a reputation marketplace between campaigns, activists, and groups.

# Developers

## Getting Started

Clone the project:

``` shell
$ git clone https://github.com/affinityworks/main
$ cd main
```

Or (via ssh):

``` shell
$ git clone git@github.com:affinityworks/main.git
$ cd main
```

The project requires the following system-level dependencies:

* `postgresql` v 9.6: our database!
* `redis` v 4.0.6: a cache to store frequently-retrieved things in memory instead of on disk
* `ruby` v 2.3.3: the programming language in which the bulk of the app is written
* `nodejs` v 6.9.0: enables us to transpile "es6"-flavored js into js that will run in all browsers
* `bundler` v 1.x: the package manager for ruby
* `yarn` v 1.x: yet another javacript package manager

Below are some scripts for installing and running those dependencies using either Docker or plain old bash scripts. Feel free to take a look at `Dockerfile`, `dockercompose-yml` file, or the `run` and `install` scripts in the `bin` directory to get a sense of what's going on under the hood!

All commands assume you are located in `path/to/this/repo`.

## Docker Setup

Install [docker](https://docs.docker.com/engine/installation/) and [docker-compose](https://docs.docker.com/compose/install/), then...

**Run app:**

``` shell
$ ./bin/docker-up
```

**Run in background:**

``` shell
$ ./bin/docker-up -d
```

**Shut down:**

``` shell
$ ./bin/docker-down
```

**Run tests:**

``` shell
$ ./bin/docker-cmd "bundle exec rails test"
```

**Run arbitrary bash commands:**

``` shell
$ ./bin/docker-cmd "bundle exec rake routes"
```

**Rebuild docker container:**

``` shell
$ ./bin/docker-build "latest"
$ docker push affinityworks/web:latest
```

## Bash setup

**Note:** our bash scripts only work for Mac OSX and Debian-flavored GNU/Linux. They also enforce use of both NVM and RVM. If those constraints don't work for you, please feel free to either:

1. Use the Dockerized dev env described above.
2. Adapt the comands in our bash scripts to your liking.
3. Open an issue or pull request to help us improve the scripts! :)

**Install:**

``` shell
$ ./bin/install
```

**Run:**

``` shell
$ ./bin/run-services # first run only: start redis & postgres
$ ./bin/copy_configs # first run only: see `Secrets` section below
$ ./bin/seed-db # first run only: seed db
$ ./bin/run
```

**Shut down cleanly:**

```shell
$ kill -9 `cat tmp/pids/server/pid`
```

**Run tests:**

``` shell
$ bundle exec rails test
```

## Gotchas

**Switching btw/ docker and bash**

If you are switching between docker and bash setups, you might run into odd Devise authentication errors on login. If this happens:

Delete all caches:

``` shell
$ cd path/to/this/repo
$ rm -rf tmp/caches/
```

If that doesn't fix it, try removing the local dbs and re-seeding:

``` shell
$ psql
# drop database affinity_development;
# drop database affinity_test;
# \q
$ ./bin/seed-db
```

## Secrets Management

### Secrets For Community Contributors

We provide sample versions of encrypted config files. They are in the `config` folder with names like `some_config.yml.exampl`. For the app to run, you need to copy them all to files with names like `some_config.yml`, which you can do by running the following script:

``` shell
$ ./bin/copy_configs
```

If you would like to gain access to the encrypted credentials:

* shoot us an email at postmaster@affinity.works
* drop us a note on Slack: https://advocacycommons.slack.com
* open an issue on this repo


### Secrets For Team Members

#### Blackbox

We use [blackbox](https://github.com/StackExchange/blackbox) for secrets management.

It allows us to keep credentials under secure version control by:

* maintaining a list of sensitive files
* gitingoring the files
* encrypting the files to a whitelist of PGP keys
* allowing key-owners to decrypt and re-encrypt files with easy-to-remember commands

To use it, you will first need:

* a PGP key (If you don't have one, we recommend [GPGSuite](https://gpgtools.org/) for Mac users, and [this guide from Riseup](https://riseup.net/en/security/message-security/openpgp/gpg-keys) for Linux or Windows users)
* an admin to add your PGP public key to the whitelist at `keyrings/live/blackbox-admins.txt`

Now you can use the following **commands:**

**Decrypt all files:**

``` shell
$ ./bin/blackbox_decrypt_all_files
```

**Encrypt a newly created file:**

``` shell
$ ./bin/blackbox_register_new_file some_file_name.yml
```

**Edit an encrypted file:**

``` shell
$ ./bin/blackbox_edit_start some_file.yml.gpg
<do your editing>
$ ./bin/blackbox_edit_end some_file.yml
```

**Edit an already-decrypted file:**

``` shell
<do your editing>
$ ./bin/blackbox_edit_end some_file.yml
```

**Delete all cleartext files:**

``` shell
$ ./bin/blackbox_shred_all_files
```

**Add new public key to whitelist:**

``` shell
$ ./bin/blackbox_addadmin
$ ./bin/blackbox_shred_all_files
$ ./bin/blackbox_update_all_files # re-encrypts to new whitelist
```

Blackbox is all just shell commands! You can read them in `./bin`. If you'd like to install them on your machine so you can type `blackbox_some_command` instead of `./bin/blackbox_some_command**, you can:

**Install blackbox on your $PATH:**

``` shell
$ git clone git@github.com:StackExchange/blackbox.git
$ cd blackbox
$ make copy-install
$ cd ../ && rm -rf blackbox
```

#### Importing Partner Credentials

To import Gsuite credentials for a partner group, first:

* make sure the group is part of a network listed in `config/networks.yml`
* place a copy of the network's `service_account.json` file in `lib/imports/gsuite`
* rename the file to `some_network_google_gsuite_key.json` (where `some_network` is the snakecased version of the network's name given in `networks.yml`)

Then run:

``` shell
$ rake import_keys:gsuite
```

This will:

* place an encrypted version of the credentials in a nested folder of `lib/network_credentials`
* delete and gitignore all unencrypted versions
* automatically create a new commit to place the above changes under version control

You will likely want to amend that commit to change the commit message.

#### Updating networks.yml

To update the list of networks:

* decrypt it with `./bin/blackbox_edit_start config/networks.yml` if necessary
* add networks, groups, and organizers following the format in the file
* re-encrypt the config file with `./bin/blackbox_edit_end config/networks.yml`
* create a migration with `rake config:update_networks` as the body of the `change` method
* run `rake db:migrate` and `rake db:migrate RAILS_ENV=test`
* commit your changes and push them

## Build Javascript in Production Configuration

Webpack will automatically rebuild the dev javascript bundles on changes according to the development configuration in `client/webpack.config.js`. So it is not necessary to rebuild manually. That said, if you want to spit out a static build of the frontend that matches the production build, you can run:

``` shell
$ bundle exec rake react_on_rails:assets:webpack
```

## Configuration Note: Mailgun + Heroku

Configuring the Heroku Mailgun addon is not that fun. Hopefully you never have to do it!

Just in case you do, here is a near-exhaustive list of the steps involved in doing so:

1. Provision the Mailgun add-on (in the "Resources" tab of the `dev-affinityworks` app panel)
1. Click on it (to go to the mailgun dashboard)
1. Verify the mailgun account via email or help ticket (help ticket will be necesary if they send email to weird address)
1. Creating new domain `mg-dev.affinity.works`
1. Verify the domain by:
  a. clicking "Domains" -> "Domain Verification & DNS"
  b. observing the two `TXT` records that appear
  c. logging into gandi.net and finding the DNS records
  d. creating two `TXT` records with the values observed in step b above


## Heroku Pipeline and CI