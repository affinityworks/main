geoCheck = function (zip) {
  zipfile = 'indivisible/app/zips/' + zip + '.txt';
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

function getCampaignInfo(state) {
  $.ajax({
    type: 'GET',
    url: 'indivisible/app/campaigns/'+state+'.json',
    dataType: 'json',
    success: function (data) {
      console.log('Got campaign data for ' + state);
      console.log(data);
        var callData = {
          campaignId: data.campaign.id,
          userPhone: thisPhone,
          userLocation: thisLocation,
          script: 'overlay'
        }
        console.log('Assembled call data');
        console.log(callData);
        makeTheCall(callData);
      

    },
    fail: function (e) {
      console.log('Error fetching campaign list.');
      console.log(e);
    }
  });
}
