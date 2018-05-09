# Setting up Google OAuth

Here is what to do if you want to extend Google OAuth support to a new instance of Affinity running on a new Heroku domain.

## Adding Redirect URIs to Google Admin Panel

*NOTE: if you are adding a redirect URI for a review app, you ONLY NEED TO DO THIS STEP*

* ensure you are have admin priveleges on the Affinity Google Developer Console
* https://console.developers.google.com/apis/credentials?project=arcane-tome-198617
* click the name of the first item in the "Oauth 2.0 client ids" list, which is just "Affinity"
* in the `Valid OAuth Redirect URIs` list, add a url of the following form:
  ```
  https://myapp.herokuapp.com/admin/auth/google_oauth2_/callback
  ```
* click "Save"


## Getting Credentials

[STUB]

*Note: You probably don't need to worry about this, as it has already happened.*

## Adding Credentials to Heroku App

*NOTE:**
*- SKIP THIS STEP if you are only adding a redirect URI for a review app*
*- do this step ONLY if you are making a new production isntance of the app*

Assuming you have a new Heroku app with name `myapp`...

* Ensure that you have a file for `myapp`'s config vars in `.env.heroku/myapp.gpg`
* If you do **not** have such a file, you can clone the env vars from prod with:
  ``` shell
  $ heroku config -a affinityworks > .env.heroku/myapp
  ```
  * Place the newly created file under encrypted version control with:
  `./bin/blackbox_register_new_file .env.heroku/myapp`
* Decrypt the credentails file for editing with:
  ``` shell
  $ ./bin/blackbox_edit_start .env.heroku/myapp`
  ```
* In `.env.heroku/myapp`, ensure that the following env vars have values:
  ```
  GOOGLE_CLIENT_ID=<some_value>
  GOOGLE_CLIENT_SECRET=<some_value>
  ```
* Add the new app to the manifest of apps in `conf/heroku.yml` with:
  ``` shell
  $ ./bin/blackbox_edit_start config/heroku.yml.gpg
  <edit the file>
  ```
* Upload the credentials to heroku by running:
  ``` shell
  $ rake heroku:export_vars
  ```
* Commit credential edits to encrypted version control with:
  ``` shell
  $ ./bin/blackbox_edit_end config/heroku.yml
  $ ./bin/blackbox_edit_end .env.heroku/myapp
  ```
