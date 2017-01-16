/*Methods to control which users see what, based on referrer codes. */
modifyForm = function (referrer_settings, slug) {
  //console.log(referrer_settings);
  referrer_settings['hide opt in controls'] && $(optInCtls).hide();
  referrer_settings['opt out'] && $(optInChk).prop('checked', false);
  if (referrer_settings['hide email field']) {
    $(emailField).hide();
    $(emailField).val(referrer_settings['email field contents']);
    if (referrer_settings['email field contents'] == 'user IP') {
      retval = $.get('http://ipinfo.io', function (res) {
        $(emailField).val(res.ip + '@' + slug + '.slug');
      }, 'jsonp');
    }
  }
}
$(document).on('can_embed_loaded', function () {
  try {
    $.get('/indivisible/app/referrers.yaml', function (data) {
      if (data) {
        referrer_data = jsyaml.load(data);
        //console.log(referrer_data);
        query_string = new URLSearchParams(window.location.search);
        if (query_string.has('ref')) {
          var ref = query_string.get('ref');
          console.log('Got ref slug ' + ref);
          if (referrer_data.hasOwnProperty(ref)) {
            referrer_settings = referrer_data[ref];
          } else {
            referrer_settings = referrer_data['default']
          }
          console.log('Using ' + referrer_settings.fullname + ' settings');
          modifyForm(referrer_settings, ref);
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
