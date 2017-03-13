API
===

There is partial support for exporting data via an [OSDI v1.1.2 API](http://opensupporter.github.io/osdi-docs/) and importing data via [Action Network's customized OSDI v2 API](https://actionnetwork.org/docs/).

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

Implementation
--------------
We use [Roar](https://github.com/trailblazer/roar) to fetch data from Action Network, to parse the received JSON into Rails records, and to represent our Rails records as JSON via [JSON+HAL](http://tools.ietf.org/html/draft-kelly-json-hal-05). This re-uses a lot of JSON manipulation and hypermedia plumbing, and reduces duplication in our code. However, the Roar approach does lead many narrowly-focused modules and classes scattered throughout the Rails application. How to do things and where the code goes is not obvious, but extending existing code should be relatively easy.

Import
* Modules in Api::ActionNetwork under app/models/api/action_network each have an `import!` method. They fetch JSON from Action Network and populate an empty subclass of Api::Collections::Collection. The module then uses ActiveRecord models from app/models to save the Api::Collections::Collection resources to our database.
* Subclasses of Api::Collections::Collection in app/models/api/collections each have a `resources` instance variable that holds imported people, events, etc. They also hold pagination state. Think of them as API payloads or API request/responses. See the [OSDI People resource spec](http://opensupporter.github.io/osdi-docs/people.html). A response from an endpoint like https://actionnetwork.org/api/v2/people is more than just a list of people resources.
* Api::Collections::Representers in app/representers/api/collections define how the received JSON is mapped to Api::Collections::Collection resources.
* Each individual resource in an Api::Collections::Representer's resources is mapped by an Api::Resources::Representer in app/representers/api/resources.
* Finally, any differences between Action Network's API and OSDI v1 is defined in app/representers/api/action_network

Export
* Uses almost all the same classes as import, but in reverse. For example, our Api::V1::PeopleController responds to request for JSON by creating an Api::Collections::People instance, populating it with paginated Active Records (`Person.page(0)`), and passing that to a Api::Collections::PeopleRepresenter.
* ActiveRecord
* Api::Collections::Collection
* Api::Collections::PeopleRepresenter
* Api::Collections::PersonRepresenter

Duplicate code is extracted into superclasses and modules, expect for the modules in Api::ActionNetwork which still share similar code.
