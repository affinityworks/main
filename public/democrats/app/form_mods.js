//Modify the AN form to look the way we want it to.

$(document).on('can_embed_loaded', function () {
  
  //Move the opt in controls to above the start calling button.
  $(optInCtls).detach().css('margin-bottom', '20px');
  $('input#phone').after(optInCtls);
  $('li#d_sharing_opts').slideDown();
  $('a#edit_d_sharing_opts').parent().remove();
  
  //Change the text on the opt-in controls
  $('li#d_sharing_opts label').get(0).lastChild.nodeValue = 'Send me regular action alerts to stop Trump nominees';
  
  //Move the disclaimer to the bottom
  disclaimer = $('li#d_sharing ul li').first();
  $(disclaimer)
    .detach()
    .addClass('new-disclaimer')
    .html('You will receive updates from <em>Democrats.com,</em> the sponsor of this form.');
  $('form#new_answer ul').first().append(disclaimer);
});

$(document).on('can_embed_submitted', function () {
	//Remove the embed block.
  $('div.clearfix div.can_thank_you-block').last().remove();
});