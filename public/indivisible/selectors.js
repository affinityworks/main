$(document).on('can_embed_loaded', function() {
  console.log('Form loaded.');
  phoneField = $('#phone');
  zipField = $('#form-zip_code');
  emailField = $('#form-email');
  theForm = $('form#new_answer');
  $(theForm).submit(function(event) {
    event.preventDefault();
    makeTheCall();
  });
});