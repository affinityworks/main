$(document).on('can_embed_loaded', function() {
  console.log('Form loaded.');
  phoneField = $('#phone');
  zipField = $('#form-zip_code');
  emailField = $('#form-email');
  theForm = $('form#new_answer');
  optInChk = $("input#name_optin1");
	optInCtls = $('li#d_sharing');
  $(theForm).submit(function(event) {
    makeTheCall();
  });
});