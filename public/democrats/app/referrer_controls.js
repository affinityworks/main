//Define the module & dependencies, and allow js-yaml to be accessed!
define(['js-yaml.min','jquery','form'],function(jsyaml,jquery,form){

	/*Methods to control which users see what, based on referrer codes. */
	modifyForm = function (settings, slug) {
		settings['hide opt in controls'] && $(optInCtls).hide();
		settings['opt out'] && $(optInChk).prop('checked', false);
		if (settings['hide email field']) {
			$(emailField)
				.hide()
				.val(settings['email field contents']);
			if (settings['email field contents'] == 'user IP') {
				$.get('http://ipinfo.io', function (res) {
					$(emailField).val(res.ip + '@' + slug + '.slug');
				}, 'jsonp');
			}
		}
	}

	$(document).on('can_embed_loaded', function (yaml) {
		query_string = new URLSearchParams(window.location.search);
		if (query_string.has('referrer')) {
			var ref = query_string.get('referrer');
			console.log('Got ref slug ' + ref);
			$.get('/democrats/app/referrers.yaml', function (data) {
				if (data) {
					referrers = jsyaml.load(data);
					settings = referrers['default']
					if (referrers.hasOwnProperty(ref)) { settings = referrers[ref]; }
					console.log('Using ' + settings.fullname + ' settings');
					modifyForm(settings, ref);
				} else {
					console.log('Error while reading YAML referrer data.');
				}
			}, 'text');
		}
	});
});