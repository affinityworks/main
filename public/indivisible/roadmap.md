**TODO**
--Provide error handler if *no* campaign is active.
-Change handleScript to handleCallResponse
-Implement can_embed_submitted for thank-you page DOM changes.
-Get JS from Matt for client IP lookup.


**Done**
-Finish all styles: 1.16
-Write referrer code function: 1.16
-Figure out require.js: done, not using 1.17
-Get trailing slash redirects working. 1.17
-Direct users to different CP campaigns based on zipcode: 1.17
--Simplify the IP detection so it just gets their IP – probably don't need the API. 1.18 (yes we do need it)
-Have campaign.js check if campaign.active is TRUE before calling 1.18
-Email info@actionnetwork.org to find out if there's a JS event for when the thank you page loads too. DONE 1.18
-Change handleScript error handler to display error on the page for user's information. 1.18