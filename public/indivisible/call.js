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

validateEmail = function() {
  return !$(emailField).hasClass('error_input');
}
commanderData = function() {
  thisPhone = validatePhone($(phoneField).val());
  thisLocation = validateZip($(zipField).val());
  hasEmail = validateEmail();
  console.log("Phone is " + thisPhone);
  console.log("ZIP is " + thisLocation);
  console.log("Email is " +hasEmail);
  if (thisPhone && thisLocation && hasEmail) {

    var data = {
      campaignId: '2',
      userPhone: thisPhone,
      userLocation: thisLocation,
      script: 'overlay',
    };
    console.log('Data looks good.');
    return data;

  } else {
    console.log("Found some data errors.");
    error_msg = 'To connect you to your senator we need:';
    if (!thisPhone) error_msg += '\n -your US phone number';
    if (!thisLocation) error_msg += '\n -your ZIP code';
    if (!hasEmail) error_msg += '\n -valid email address';
    alert(error_msg);
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
