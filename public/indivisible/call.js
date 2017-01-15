validatePhone = function(num) {
  console.log("Validating '" + num + "' as phone number");
  num = num.replace(/[^0-9]/g, '')
  if (num.substring(0, 1) != '1') num = "1" + num;
  if (num.length == 11) return num;
  return false;
}

// Thanks to https://stackoverflow.com/questions/160550/zip-code-us-postal-code-validation for ZIP validation regex
validateZip = function(zip) {
  console.log("Validating '" + zip + "' as ZIP");
  if (/(^\d{5}$)|(^\d{5}-\d{4}$)/.test(zip)) return zip
  return false
}


commanderData = function() {
  userPhone = validatePhone($('#phone').val());
  userLocation = validateZip($('#form-zip_code').val());
  console.log("Phone is " + userPhone);
  console.log("ZIP is " + userLocation);
  if (userPhone && userLocation) {

    var data = {
      campaignId: '2',
      userPhone: $('#phone').val(),
      userLocation: $('#form-zip_code').val(),
      script: 'overlay',
    };
    console.log('Data looks good.');
    return data;

  } else {
    console.log("Found some data errors.");
    
    
    return false
  }
}


makeTheCall = function() {
  data = commanderData();
  if (data) {
    $.ajax({
      method: 'get',
      data: data,
      url: 'https://advocacycommons.callpower.org/api/call/create',
      dataType: 'json',
      complete: function(res) {
        console.log("AJAX done");
        console.log(res);
      }

    });
  }
}
