$(document).on('can_embed_loaded', function () {
  console.log('Form loaded.');
  phoneField = $('#phone');
  zipField = $('#form-zip_code');
  emailField = $('#form-email');
  theForm = $('form#new_answer');
  optInChk = $('input#name_optin1');
  optInCtls = $('li#d_sharing');
  form_title=$('div#can_main_col h2').text();
  
  //Move the opt in controls to above the start calling button.
  $(optInCtls)
   .detach()
   .insertAfter('input#phone')
   .css('margin-bottom','20px');
  $('li#d_sharing_opts').slideDown();
  $('a#edit_d_sharing_opts').remove();
  
  $(theForm).submit(function (event) {
    commanderData();
  });
});
