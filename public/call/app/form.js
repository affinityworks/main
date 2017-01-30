$(document).on('can_embed_loaded', function () {
  console.log('Form loaded.');
  phoneField = $('#phone');
  zipField = $('#form-zip_code');
  emailField = $('#form-email');
  theForm = $('form#new_answer');
  optInChk = $('input#name_optin1');
  optInCtls = $('li#d_sharing');
  form_title = $('div#can_main_col h2').text();
  head_container = $('div#heads');
  $('a#terms_link').click(function(){
		alert("Advocacy Commons SMS Terms & Conditions:\nBy signing up and entering my telephone number, I consent to receive and authorize Advocacy Commons to send (i) SMS text messages, (ii) prerecorded audio messages (including calls to cellular phones), or (iii) other communications sent by an autodialer to my mobile device.");
	});
});

replaceThankYou = function (targetHTML) {
  $('div#action_thank_you_text').html(targetHTML);
}
