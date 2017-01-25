$(document).on('can_embed_loaded', function () {
  console.log('Form loaded.');
  phoneField = $('#phone');
  zipField = $('#form-zip_code');
  emailField = $('#form-email');
  theForm = $('form#new_answer');
  optInChk = $('input#name_optin1');
  optInCtls = $('li#d_sharing');
  form_title = $('div#can_main_col h2').text();
<<<<<<< HEAD
  head_container = $('div#heads');
=======
>>>>>>> d57049f836082947a833bd905c776954ff7caaa4
  
  $(theForm).submit(function (event) {
    commanderData();
  });
});

replaceThankYou = function (targetHTML) {
<<<<<<< HEAD
  $('div#action_thank_you_text').html(targetHTML);
=======
  $('div#action_thank_you_text').text(targetHTML);
>>>>>>> d57049f836082947a833bd905c776954ff7caaa4
}
