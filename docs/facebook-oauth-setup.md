# Setting up FB OAuth

Here is what to do if you want to extend FB OAuth support to a new instance of Affinity running on a new Heroku domain.

## Getting Credentials

[STUB]

(You probably don't need to worry about this, as it has already happened.)

## Adding Credentials to Heroku App

Assuming you have a new Heroku app with name `myapp`...

* Decrypt all credentials files with `./bin/blackbox_decrypt_all_files`
* Find the following four env vars in `.env.heroku/affinityworks` [1]:
```
FACEBOOK_API_KEY=<some_value>
FACEBOOK_API_SECRET=<some_value>
FACEBOOK_APP_ID=<some_value>
FACEBOOK_APP_SECRET=<some_value>
```
* Upload the credentials to heroku by:
  * copy/pasting the variable assignment statements above into `lib/export/heroku/myapp`
  * running:
  ``` shell
  $ rake heroku:export_vars
  ```
* Place the credentials under version control by:
  * copy/pasting the assignment statements into `.env.heroku/myapp`
  * re-encrypting and committing these changes with `./bin/blackbox_edit_end .env.heroku/myapp`

## Adding Redirect URIs to FB Admin Panel

* ensure you are have admin priveleges on the Affinity Facebook app
* login to https://developers.facebook.com/apps/629022460623234/fb-login/settings/
* in the `Valid OAuth Redirect URIs`, add listings of the following form:
```
https://myapp.herokuapp.com/admin/auth/facebook/callback
https://myapp.herokuapp.com/admin/auth/facebook/callbackRemove
```
* click "Save"

## Submiting To Login Review

FB has a vetting process called "Login Review" for apps that require any permissions in addition to `email` and `public_profile`. As such, in order to request user's event information, we will have to go through this vetting process. Until then, we cannot sync events with FB.

You can learn more about the process here:

https://developers.facebook.com/docs/facebook-login/review/
