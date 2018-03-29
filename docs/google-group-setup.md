# Setting Up A New Google Group Integration

Affinity offers integration with Google Groups. However, for us to provide a Google Group for your organization, you need to perform the following steps ONCE AND ONLY ONCE, with support from the Affinity staff:

1. Go to [Google Cloud Platform](https://console.developers.google.com/projectselector/iam-admin/serviceaccounts)
2. Click create
3. Click the edit link under the Project name text field to reveal a second field for Project ID
4. Enter “My National Network” (or whatever you think is appropriate for the overall National project) as the project name, and leave the auto generated project ID as is.
5. Click create.
6. On the “Service account management” page, click “Create service account”
7. Enter “Affinity” as the Service account name
8. In the “Role” dropdown, select Project, then Owner
9. Check the box for “Furnish a new private key”
10. Check the box for “Enable G Suite Domain-wide delegation”
11. Enter “Affinity” for the “Product name for the consent screen” text field
12. Click create
13. This will prompt a window to save the private key file, click save and save the file as “swing-left-service-account”
14. Go to [Google Cloud Platform](https://console.developers.google.com/permissions/serviceaccounts)
15. Click select
16. Select the just created project
17. Click open
18. On the right hand column, click the link “View Client ID”
19. Copy down the Client ID for an upcoming step
20. Go to [Sign in - Google Accounts](http://admin.google.com/)
21. Select Security from the list of controls. If you don't see Security listed, select More controls from the gray bar at the bottom of the page, then select Security from the list of controls. If you can't see the controls, make sure you're signed in as an administrator for the domain.
22. Select Show more and then Advanced settings from the list of options.
23. Select Manage API client access in the Authentication section.
24. In the Client Name field enter the service account's Client ID (that you just wrote down in Step 19)
25. In the One or More API Scopes text field, copy in https://www.googleapis.com/auth/admin.directory.group', 'https://www.googleapis.com/auth/admin.directory.group.member', 'https://www.googleapis.com/auth/apps.groups.settings  (with the commas in between the URLs)
26. Click authorize
27. Send us the private key you downloaded in step 13!
28. Go to [admin.google.com](http://admin.google.com/) and sign in (if not already)
29. Click on the Apps square
30. Click on the G Suite square
31. Click on the Groups for business row (not the checkbox)
32. Click advanced settings
33. Under “Outside this domain - access to groups”, select “Public on the internet”
34. Under “Default View Topics permission”, select “All members of the group”
35. Under “Creating groups”, select “Anyone in this domain can create groups”
36. Under “Member and email access”, check both checkboxes
