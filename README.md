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
$ ./bin/seed-db # first run only: seed db
$ ./bin/run-web
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

## Bnuild Javascript in Production Configuration

Webpack will automatically rebuild the dev javascript bundles on changes according to the development configuration in `client/webpack.config.js`. So it is not necessary to rebuild manually. That said, if you want to spit out a static build of the frontend that matches the production build, you can run:

``` shell
$ bundle exec rake react_on_rails:assets:webpack
```

## Testing Note: Mailgun on Heroku Review apps

Testing email features on Heroku review apps is a bit tricky.

To successfully verify that an email feature works, you will need to:

1. Log into the heroku cli
1. Use the cli to copy mailgun credentials from `dev-affinityworks` app to your local machine
1. Use the cli to copy those credentials from your local machine to `dev-affinityworks-pr-<PR_NUMBER_HERE>`

Here is a representative shell session of that process (with credentials redacted):

``` shell
$ heroku login
$ heroku config --app dev-affinityworks | clip
```

You should now have all the environment variables for the review app in your clipboard. If you paste them into a text file, it should look something like:

```txt
=== dev-affinityworks-pr-520 Config Vars
DATABASE_URL:                 postgres://<some_url>
HEROKU_POSTGRESQL_BRONZE_URL: postgres://<some_url>
LANG:                         en_US.UTF-8
MAILGUN_API_KEY:              key-<some_hex_string>
MAILGUN_DOMAIN:               mg-staging.affinity.works
MAILGUN_PUBLIC_KEY:           pubkey-<some_hex_string>
MAILGUN_SMTP_LOGIN:           postmaster@mg-staging.affinity.works
MAILGUN_SMTP_PASSWORD:        <some_hex_string>
MAILGUN_SMTP_PORT:            587
MAILGUN_SMTP_SERVER:          smtp.mailgun.org
RACK_ENV:                     production
RAILS_ENV:                    production
RAILS_LOG_TO_STDOUT:          enabled
RAILS_SERVE_STATIC_FILES:     enabled
REDIS_URL:                    redis://<some_url>
SECRET_KEY_BASE:              <some_hex_string>
```

(Note that we are currently copying the config vars from staging, which is sort of weird, but necessary for `reasons`.)

In order to upload the mailgun-related credentials to your review app -- assuming a staging app called `dev-affinityworks-pr-666` (NOTE: the number of your PR will differ!) -- you would then perform the appropriate text-munging to issue the following cli commands:

```shell
$ heroku config:set MAILGUN_API_KEY=key-<some_hex_string> -a dev-affinityworks-pr-666
$ heroku config:set MAILGUN_DOMAIN=mg-staging.affinity.works -a dev-affinityworks-pr-666
$ heroku config:set MAILGUN_PUBLIC_KEY=pubkey-<some_hex_string> -a dev-affinityworks-pr-666
$ heroku config:set MAILGUN_SMTP_LOGIN=postmaster@mg-staging.affinity.works -a dev-affinityworks-pr-666
$ heroku config:set MAILGUN_SMTP_PASSWORD=<some_hex_string> -a dev-affinityworks-pr-666
$ heroku config:set MAILGUN_SMTP_PORT=587 -a dev-affinityworks-pr-666
$ heroku config:set MAILGUN_SMTP_SERVER=smtp.mailgun.org -a dev-affinityworks-pr-666
```

This should configure the review app to send emails.

Now we issue this command to configure it with the proper hostname (so that links in emails are correct):

``` shell
$ heroku config:set HOSTNAME=$(heroku info --app <app_name> -s | grep web_url | cut -d= -f2)
```

And finally, we make sure that all workers are running (so that emails get sent in the background), with:

``` shell
$ heroku ps:restart worker -a dev-affinityworks-pr-666
```

Could this whole process be simplified drastically? YOU BETCHA!!! Let's do that in an upcoming card. :P


## Configuration Note: Mailgun + Heroku

It is sort of janky to use the staging credentials for dev. For one, it necessitates the manual copying process above. Secondly, if we ever delete the staging app, we won't have a free mailgun account to use for acceptance testing.

Thus, at some point in the future, it will likely make sense for us to set up a dedicated `dev` mailgun account.

At such point, a (hopeuflly exhaustive) set of steps for configuring the mailgun account are:

1. Provision the Mailgun add-on (in the "Resources" tab of the `dev-affinityworks` app panel)
1. Click on it (to go to the mailgun dashboard)
1. Verify the mailgun account via email or help ticket (help ticket will be necesary if they send email to weird address)
1. Creating new domain `mg-dev.affinity.works`
1. Verify the domain by:
  a. clicking "Domains" -> "Domain Verification & DNS"
  b. observing the two `TXT` records that appear
  c. logging into gandi.net and finding the DNS records
  d. creating two `TXT` records with the values observed in step b above

## Spurious header that isn't good for anything
