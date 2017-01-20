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
  
  if (thisPhone & thisLocation) geoCheck(thisLocation);
  if (!thisPhone) console.log('No phone number.');
  if (!thisLocation) console.log('No location.'); 
}

handleCallResponse = function (res) {
  console.log(res);
  if (res.status == '200') {
    console.log('Got response 200 OK');
    targetHTML = res.responseJSON.script;
  } else {
    console.log('Got response ' + res.status + ' ' + res.statusText);
    targetHTML = 'There was an error with your call (' + res.status + ' ' + res.statusText + '0.  Please <a href="http://www.advocacycommons.org/indivisible/">try again</a>.'
  }
  
  $(document).on('thank_you_ready',function(){
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
