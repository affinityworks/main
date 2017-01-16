/*This script will provide methods for controlling which users see what, based on referrer codes. */

optInChk = $("#name_optin1");
optInCtls = $('li#d_sharing');
modifyForm = function(referrer_settings) {
  console.log(referrer_settings);
  
}


$(document).ready(function(){
	try {
		$.get('app/referrers.yaml',function(data){
			if (data) {
				referrer_data = jsyaml.load(data);
				console.log(referrer_data);
			
				query_string = new URLSearchParams(window.location.search);
				if(query_string.has('ref')){
					var ref = query_string.get('ref');
					console.log('Got ref slug ' + ref);
					if(referrer_data.hasOwnProperty(ref)) {
						referrer_settings = referrer_data[ref];
						console.log('Found referrer ' + referrer_settings.fullname);
						$(document).on('can_embed_loaded', modifyForm(referrer_settings));
					}
				} else {
			
				}
			
			} else {
				console.log('Error while reading YAML referrer data.');
			}
		}, 'text');
	
	} catch (e) {
		console.log(e);
	}
});