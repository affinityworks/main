**TODO**
--Responsive font sizing.
--Consider server-side IP lookup instead of API.


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
-Change handleScript to handleCallResponse 1.18
-Implement can_embed_submitted for thank-you page DOM changes.
-Force user to fill out all fields even if already logged in DONE 1.18
-Provide error handler if *no* campaign is active.  Use AN share functions? 1.18