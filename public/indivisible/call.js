validatePhone = function(num) {
  console.log("Validating '" + num + "' as phone number");
  num = num.replace(/[^0-9]/g, '')
  if (num.substring(0, 1) != '1') num = "1" + num;
  if (num.length == 11) return num;
  return false;
}


commanderData = function() {
  thisPhone = validatePhone($(phoneField).val());
  thisLocation = $(zipField).val();
  console.log("Phone is " + thisPhone);
  console.log("ZIP is " + thisLocation);

  if (thisPhone) {

    var data = {
      campaignId: '2',
      userPhone: thisPhone,
      userLocation: thisLocation,
      script: 'overlay',
    };
    console.log('Data looks good.');
    return data;

  } else {
    console.log('No phone number.');
    //No use notifying the user, because I haven't figured out how to stop the AN form submission.
    //alert('Please enter a valid US phone number.');

  }
}


makeTheCall = function() {
  data = commanderData();
  if (data) {
    $.ajax({
      method: 'get',
      data: data,
      url: 'https://call-power-advocacycommons.herokuapp.com/call/create',
      dataType: 'json',
      complete: function(res) {
        console.log("AJAX done");
        console.log(res);

      }

    });
  }
}
