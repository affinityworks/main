$(document).on('can_embed_loaded', function(){
	$(theForm).submit(function (event) {
    commanderData();
  });
});

validatePhone = function (num) {
  console.log('Validating \'' + num + '\' as phone number');
  num = num.replace(/[^0-9]/g, '')
  if (num.substring(0, 1) != '1') num = '1' + num;
  if (num.length == 11) return num;
  return false;
}

commanderData = function () {
  thisPhone = validatePhone($(phoneField).val());
  thisLocation = $(zipField).val();
  console.log('Phone is ' + thisPhone);
  console.log('ZIP is ' + thisLocation);
  if (!thisLocation) console.log('No location.'); 
  if (thisPhone) { 
    //For now, comment out the state-by-state campaign function.  Make a prettier way of doing this later on.
    //geoCheck(thisLocation);
    var callData = {
        campaignId: '7',
        userPhone: thisPhone,
        userLocation: thisLocation,
      }
		console.log('Assembled call data');
		console.log(callData);
		makeTheCall(callData);
  } else {
		console.log('No phone number.');
  }
  
}

handleCallResponse = function (res) {
  console.log(res);
  if (res.status == '200') {
    console.log('Got response 200 OK');
    targetHTML = res.responseJSON.script;
  } else {
    console.log('Got response ' + res.status + ' ' + res.statusText);
    targetHTML = 'Looks like there was an error with your call (' + res.status + ' ' + res.statusText + ').  Reload the page and give it another shot.'
  }
  
  $(document).on('can_embed_submitted',function(){
    replaceThankYou(targetHTML)
  });
  
}

makeTheCall = function (data) {
  if (data) {
    $.ajax({
      method: 'get',
      data: data,
      url: 'https://advocacycommons.callpower.org/call/create',
      dataType: 'json',
      complete: function (res) {
        handleCallResponse(res);
      }
    });
  }
}
