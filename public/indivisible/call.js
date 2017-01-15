makeTheCall = function() {
var data = {
  campaignId: '2',
  userPhone: $('#phone').val(),
  userLocation: $('#form-zip_code').val(),
  script: 'overlay',
};
$.ajax({
method: 'get',
data: data,
url: 'https://advocacycommons.callpower.org/api/call/create',
dataType: 'json',
complete: function(res){
  console.log("AJAX done");
  console.log(res);
}

});
}