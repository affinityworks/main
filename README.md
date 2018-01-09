# Affinity

Affinity.works is supporting the surge of resistance against Trump. It's coming at it in two ways. First, working with the new activist groups that have sprung up, building MVP's to solve the problems they've encountered in their organizing. Second, Affinity is enabling rapid collaboration between the grassroots and the big national networks like Indivisible & Daily Kos, to defend the institutions of democracy.

Concretely, the tool is a SaaS and has components for managing a network of groups, a crm, task management for volunteers, outreach, and a reputation marketplace between campaigns, activists, and groups.

# Status:
This project is a work in progress and nothing which is useable by end users is available. We welcome developer / designer / activist collaboration.

# Developers

## Getting Started

Clone the project:

*(the rest of guide assumes you are in `path/to/this/repo`)*

``` shell
$ git clone https://github.com/advocacycommons/advocacycommons
$ cd advocacycommons
```
The project requires the following system-level dependencies:

* `postgresql` v 9.6: our database!
* `redis` v 4.0.6: a cache to store frequently-retrieved things in memory instead of on disk
* `ruby` v 2.3.3: the programming language in which the bulk of the app is written
* `nodejs` v 6.9.0: enables us to transpile "es6"-flavored js into js that will run in all browsers
* `bundler` v 1.x: the package manager for ruby
* `yarn` v 1.x: yet another javacript package manager

We strongly recommend using the `rvm` and `nvm` version management systems for `ruby`, and `nodejs`, respectively, and our guide will assume you use them.

You could install the above dependencies manually or use Docker to do that for you. We'll show both ways...

### Install and Run With Docker

TK-TODO

### Installing Manually

#### System Dependencies on Debian-flavored GNU/Linux

Install packages (also get some pgp keys we'll need to verify yarn package):

``` shell
$ sudo su
# apt remove cmdtest # uses same command name as `yarn`
# curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
# echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
# apt update && apt upgrade
# apt install -y redis postgresql postgresql-client postgresql-all yarn
# exit # done w/ root privileges for now :)
```

#### System Dependencies on MacOS

Install Homebrew (package manager for Mac) and `brew services` (which lets you run Homebrew packages as long-running background daemons):

``` shell
$ /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
$ brew tap homebrew/services
```

Install packages:

``` shell
$ brew install postgresql redis
$ brew install yarn --without-node
```

### Application Dependencies

Install rvm and ruby:

``` shell
$ curl -sSL https://get.rvm.io | bash -s stable --ruby
$ source ~/.rvm/scripts/rvm
$ rvm install 2.3.3
$ rvm use 2.3.3
$ gem install bundler
```

Install ruby dependencies:

``` shell
$ ./bin/bundle install
```

Install nvm and node:

``` shell
$ curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash
$ echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.bashrc
$ echo '[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"' >> ~/.bashrc
$ nvm install 6.9.0
$ nvm use 6.9.0
```

Install javascript dependencies:

``` shell
$ yarn install
```

Configure the development database:

``` shell
$ source ./bin/env
$ sudo -u postgres createuser affinity -s
$ sudo -u postgres psql -c  "alter user affinity with encrypted password '${AFFINITY_DEV_DB_PASSWORD}';"
$ rake db:setup
```

### Run Application

Start long-running background services that support the app:

On Debian:

``` shell
$ systemctl start postgresql
$ systemctl start redis-server
$ npm run resqueue
```

On Mac:

``` shell
$ brew services start postgresql
$ brew services start redis
$ npm run resqueue
```

Run the app:

``` shell
$ npm start
```

**BEGIN!!**

Open http://localhost:3000/ and login as `organizer@member.com` with password `password`.

**GOTCHAS:**

You might need some secrets that are stored in environment variables! Read those environment variables into memory with:

``` shell
$ cd path/to/this/repo
$ source ./bin/env
```

## Run Tests

``` shell
$ rails test
```

## Build Javascript in Production Configuration

Webpack will automatically rebuild the dev javascript bundles on changes according to the development configuration in `client/webpack.config.js`. So it is not necessary to rebuild manually. That said, if you want to spit out a static build of the frontend that matches the production build, you can run:

``` shell
rake react_on_rails:assets:webpack
```
