$(document).on('can_embed_loaded', function() {
  console.log('Form loaded.');
  $(window).on('hashchange',handleScript(res));
  phoneField = $('#phone');
  zipField = $('#form-zip_code');
  emailField = $('#form-email');
  theForm = $('form#new_answer');
  $(theForm).submit(function(event) {
    makeTheCall();
  });
});