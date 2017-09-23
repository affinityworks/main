# Affinity

Affinity.works is supporting the surge of resistance against Donald Trump. It's coming at it in two ways. First, working with the new activist groups that have sprung up, building MVP's to solve the problems they've encountered in their organizing. Second, Affinity is enabling rapid collaboration between the grassroots and the big national networks like Indivisible & Daily Kos, to defend the institutions of democracy.

Concretely, the tool is a SaaS and has components for managing a network of groups, a crm, task management for volunteers, outreach, and a reputation marketplace between campaigns, activists, and groups.

# Status:
This project is a work in progress and nothing which is useable by end users is available. We welcome developer / designer / activist collaboration.

# Developers

## Getting Started
* Install Postgresql with dev libraries
* Install node.js
* Install Ruby 2.3.3
* Install & run bundler
* Install & run yarn
* Build webpack -  rake react_on_rails:assets:webpack 
* Install & run redis
* Run Resque:  RUN_AT_EXIT_HOOKS=yes rake environment resque:work QUEUE=*
* cd client && yarn install
* Ubuntu: `sudo -u postgres createuser $USER -s`
* `rake db:setup`

## Run Tests
`rails test`

## Run Server
`npm run rails-server`
Open http://localhost:3000/
