# Setting up FB OAuth

Here is what to do if you want to extend Google OAuth support to a new instance of Affinity running on a new Heroku domain.

## Getting Credentials

[STUB]

*Note: You probably don't need to worry about this, as it has already happened.*

## Adding Credentials to Heroku App

*NOTE: we are working on a more efficient upload workflow than this. But this works for now.*

Assuming you have a new Heroku app with name `myapp`...

* Decrypt all credentials files with `./bin/blackbox_decrypt_all_files`
* Find the following four env vars in `.env.heroku/affinityworks` [1]:
```
GOOGLE_CLIENT_ID=<some_value>
GOOGLE_CLIENT_SECRET=<some_value>
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

* ensure you are have admin priveleges on the Affinity Google Developer Console
* https://console.developers.google.com/apis/credentials?project=arcane-tome-198617
* click the name of the first item in the "Oauth 2.0 client ids" list, which is just "Affinity"
* in the `Valid OAuth Redirect URIs` list, add a url of the following form:
  ```
  https://myapp.herokuapp.com/admin/auth/facebook/callbackRemove
  ```
* click "Save"
