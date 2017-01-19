$(document).on('can_embed_loaded', function () {
  console.log('Form loaded.');
  phoneField = $('#phone');
  zipField = $('#form-zip_code');
  emailField = $('#form-email');
  theForm = $('form#new_answer');
  optInChk = $('input#name_optin1');
  optInCtls = $('li#d_sharing');
  form_title = $('div#can_main_col h2').text();
  //Move the opt in controls to above the start calling button.
  $(optInCtls).detach().css('margin-bottom', '20px');
  $('input#phone').after(optInCtls);
  $('li#d_sharing_opts').slideDown();
  $('a#edit_d_sharing_opts').parent().remove();
  //Change the text on the opt-in controls
  $('li#d_sharing_opts label').get(0).lastChild.nodeValue = 'Send me regular action alerts to stop Trump nominees';
  //Move the disclaimer to the bottom
  disclaimer = $('li#d_sharing ul li').first();
  $(disclaimer).detach().addClass('new-disclaimer');
  $('form#new_answer ul').first().append(disclaimer);
  $(theForm).submit(function (event) {
    commanderData();
  });
});
replaceThankYou = function (targetHTML) {
  //Call this function once the thank you page has loaded.
  if (!targetHTML) targetHTML = $('div#action_thank_you_text').html();
  //Remove the embed block.
  $('div.clearfix div.can_thank_you-block').last().remove();
  //Remove the thank you div.
  $('div#can_thank_you').remove();
  actionDiv = $('<div>').addClass('action_description').html(targetHTML).addClass('whitespacefix');
  newh2 = $('<h2>').text(form_title);
  $('div#can_embed_form').prepend(actionDiv).prepend(newh2);
}
