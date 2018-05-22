# Setting up FB OAuth

Here is what to do if you want to extend FB OAuth support to a new instance of Affinity running on a new Heroku domain.

## Adding Redirect URIs to FB Admin Panel

*NOTE: if you are adding a redirect URI for a review app, ONLY  DO THIS STEP*

Assuming you want to add redirect URIs for an app with hostname `myapp.heroku.com`:

* ensure you are have admin priveleges on the Affinity Facebook app
* login to https://developers.facebook.com/apps/629022460623234/fb-login/settings/
* in the `Valid OAuth Redirect URIs`, add listings of the following form:
```
https://myapp.herokuapp.com/admin/auth/facebook/callback
https://myapp.herokuapp.com/admin/auth/facebook/callbackRemove
```

* click "Save"

## Getting Credentials

[STUB]

(You probably don't need to worry about this, as it has already happened.)

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
  FACEBOOK_API_KEY=<some_value>
  FACEBOOK_API_SECRET=<some_value>
  FACEBOOK_APP_ID=<some_value>
  FACEBOOK_APP_SECRET=<some_value>
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

## Submiting To Login Review

FB has a vetting process called "Login Review" for apps that require any permissions in addition to `email` and `public_profile`. As such, in order to request user's event information, we will have to go through this vetting process. Until then, we cannot sync events with FB.

You can learn more about the process here:

https://developers.facebook.com/docs/facebook-login/review/
