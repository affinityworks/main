API
===

There is partial support for exporting data via an [OSDI v1.0 API](http://opensupporter.github.io/osdi-docs/) and importing data via [Action Network's customized OSDI v2 API](https://actionnetwork.org/docs/).

The API should be reasonably performant but hasn't been tested with large datasets.

Export
------
To test in development, follow the steps below. Production would use external hostnames.

```
rails s
rails c
Api::User.create!(email: 'api_user@example.com', osdi_api_token: 'some_token', password: 'some_password', name: 'API user')
```

Open http://localhost:3000/hal-browser/browser.html#/api/v1
Use osdi_api_token from previous step as OSDI-API-Token header to browse http://localhost:3000/api/v1/people

Import
------
Supports import of Events, People, and Attendances. Requires ACTION_NETWORK_API_TOKEN set in ENV. There are no external endpoints for the import API yet.

```
DISABLE_SPRING=1 ACTION_NETWORK_API_TOKEN=${token} rails c
Api::People.import!
Api::Events.import!

# Just an example. In a complete application, you would choose the event from a UI.
event = Event.last

Api::Attendances.import!(event)
```

(The DISABLE_SPRING is needed if ACTION_NETWORK_API_TOKEN wasn't set before Rails Spring started.)

Each import! method:
 * Creates new resources (event/person/attendance)
 * Merges attributes from more recent versions of existing resources
 * Ignores existing, unchanged resources
 * Ignores more-recently modified resources—assumes that we've made a change in _our_ system and we don't want to over-write our change.

Imports can be run and re-run in any order. However, Api::Attendances requires an existing event, and it only associates attendances with existing people. In other words, Api::People should be run before Api::Attendances.

There are many missing features. For instance, the API only imports the first page of data and doesn't follow pagination links.
