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

Below are some scripts for installing and running those dependencies from a bash shell. If you want to see what's going on under the hood, feel free to peek at the scripts!

### Install Application from shell

From `path/to/this/repo`, run:

``` shell
$ ./bin/install
```

### Run Application from shell

From `path/to/this/repo`, run:

``` shell
$ ./bin/run
```

## Run Tests

From `path/to/this/repo`, run:

``` shell
$ rails test
```

## Build Javascript in Production Configuration

Webpack will automatically rebuild the dev javascript bundles on changes according to the development configuration in `client/webpack.config.js`. So it is not necessary to rebuild manually. That said, if you want to spit out a static build of the frontend that matches the production build, you can run:

``` shell
rake react_on_rails:assets:webpack
```
