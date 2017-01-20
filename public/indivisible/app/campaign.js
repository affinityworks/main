geoCheck = function (zip) {
  zipfile = '/indivisible/app/zips/' + zip + '.txt';
  console.log('Looking at ' + zipfile);
  $.ajax({
    type: 'GET',
    url: zipfile,
    dataType: 'text',
    cache: false,
    success: function (data) {
      console.log('Got state ' + data);
      getCampaignInfo(data);
    }
  });
}

function noActiveCampaign(state) {
  console.log('No active campaign for ' + state);
  $(document).on('can_embed_submitted', function () {
    replaceThankYou(false);
  });
}

function getCampaignInfo(state) {
  campaignDataRequest = $.get({
    url: '/indivisible/app/campaigns/' + state + '.json',
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
      noActiveCampaign(state);
    }
  });
  campaignDataRequest.fail(function (data) {
    if (data.status == 404) {
      noActiveCampaign(state);
    } else {
      console.log('Failed campaign data request');
      console.log(data);
      $(document).on('can_embed_submitted', function () {
        replaceThankYou('Error ' + data.status + ' while getting campaign info.  Try reloading the page.');
      });
    }
  });
}

