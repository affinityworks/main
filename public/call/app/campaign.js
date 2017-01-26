geoCheck = function (zip) {
  //For the moment, use the zip files in /democrats so we don't destroy GH anymore than we already have.
  ziploc = '/zipcodes/.' + zip + '.json';
  console.log('Looking at ' + ziploc);
  $.ajax({
    type: 'GET',
    url: ziploc,
    dataType: 'json',
    cache: true,
    success: function (data) {
      console.log('Got state ' + data.state);
      getCampaignInfo(data.state);
    }
  });
}

function getCampaignInfo(state) {
  campaignDataRequest = $.get({
    //Campaign data, however, we'll load from our own dir.
    url: '/call/app/campaigns/' + state + '.json',
    dataType: 'json'
  });
  campaignDataRequest.done(function (data) {
    console.log(data);
    if (data.campaign.active) {
      var callData = {
        campaignId: data.campaign.id,
        userPhone: thisPhone,
        userLocation: thisLocation,
        script: 'overlay'
      }
      console.log('Assembled call data');
      console.log(callData);
      makeTheCall(callData);
    } else {
      console.log('No active campaign for ' + state);
    }
  });
  campaignDataRequest.fail(function (data) {
    if (data.status == 404) {
      console.log('No active campaign for ' + state);
    } else {
      console.log('Failed campaign data request');
      console.log(data);
      $(document).on('can_embed_submitted', function () {
        replaceThankYou('Error ' + data.status + ' while getting campaign info.  Try reloading the page.');
      });
    }
  });
}
