# Setting Up A New Google Group Integration

Affinity offers integration with Google Groups. However, for us to provide a Google Group for your organization, you need to perform the following steps ONCE AND ONLY ONCE, with support from the Affinity staff:

# A. Create Project
1. Go to [Google Developer Console](https://console.developers.google.com)
1. On the left side of the top nav bar, directly to the right of "Google APIs", either:
1. If you have no projects: click "Create"
1. If you have pre-existing projects: click the dropdown, then click the "+" icon in the top-right-hand corner of the pop-up that appears
1. Click the edixgt link under the Project name text field to reveal a second field for Project ID
1. Enter “My National Network” (or whatever you think is appropriate for the overall project) as the project name, and leave the auto generated project ID as is.
1. Click create.

## B. Create Service Account
1. Go to [Google Developer Console | IAM Admin | Service Accounts Page](https://console.developers.google.com/projectselector/iam-admin/serviceaccounts)
1. On the “Service account management” page, click “Create service account”
1. Enter “Affinity” as the Service account name
1. In the “Role” dropdown, select Project, then Owner
1. Check the box for “Furnish a new private key”
1. Check the box for “Enable G Suite Domain-wide delegation”
1. Enter “Affinity” for the “Product name for the consent screen” text field
1. Click create
1. This will prompt a window to save the private key file, click save and save the file as “swing-left-service-account”
1. Send us the private key you just downloaded over a secure channel. (Ask us for help if you don't know what a "secure channel" might be.)

## C. Copy Client ID
1. Go to [Google Developer Consolle | Permssions | Service Accounts Page](https://console.developers.google.com/permissions/serviceaccounts)
1. Click select
1. Select the just created project
1. Click open
1. On the right hand column, click the link “View Client ID”
1. Copy down the Client ID for an upcoming step

## D. Enable APIs
1. Go to [Google Developer Console | APIs & Services Library](https://console.developers.google.com/apis/library)
1. Search for and enable the following 3 APIs: `Admin SDK`, `Contacts API`, and `Group Settings API`
1. Verify you have successfully added the APIs by visiting the [Google Developer Console | APIs & Services Dashboard](https://console.developers.google.com/apis/library)

## E. Authorize API Clients
1. Go to [Sign in - Google Accounts](http://admin.google.com/)
1. Select Security from the list of controls. If you don't see Security listed, select More controls from the gray bar at the bottom of the page, then select Security from the list of controls. If you can't see the controls, make sure you're signed in as an administrator for the domain.
1. Select Show more and then Advanced settings from the list of options.
1. Select Manage API client access in the Authentication section.
1. In the Client Name field enter the service account's Client ID (that you just wrote down in Step 19)
1. In the One or More API Scopes text field, copy in https://www.googleapis.com/auth/admin.directory.group', 'https://www.googleapis.com/auth/admin.directory.group.member', 'https://www.googleapis.com/auth/apps.groups.settings  (with the commas in between the URLs)
1. Click authorize


## F. Set Permissions
1. Go to [admin.google.com](http://admin.google.com/) and sign in (if not already)
1. Click on the Apps square
1. Click on the G Suite square
1. Click on the Groups for business row (not the checkbox)
1. Click advanced settings
1. Under “Outside this domain - access to groups”, select “Public on the internet”
1. Under “Default View Topics permission”, select “All members of the group”
1. Under “Creating groups”, select “Anyone in this domain can create groups”
1. Under “Member and email access”, check both checkboxes
