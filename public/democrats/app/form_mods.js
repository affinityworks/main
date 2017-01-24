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
    
  //Remove the "not in the US?" dropdown link
  $('div.country_wrap').remove();
});

$(document).on('can_embed_submitted', function () {
  thank_you_div = $('div#can_thank_you');
	//Remove the embed block.
  $('div.clearfix div.can_thank_you-block').last().remove();
  
  //Change the form title
  $('div#can_thank_you h1').text('Thank you!');
  
  //Alter text of h4 and put after the thank you text
  $('div#can_thank_you h4').text('Help us build a powerful rapid response network by spreading the word using the tools below.').detach().appendTo($(thank_you_div));
  
  //Create a label for the email sample textarea
  new_label = $('<label>')
    .addClass('block mt20 graytext')
    .attr('id','email_label')
    .text('Hightlight the whole message below, then copy and paste it into an email.')
    .insertBefore('textarea#form-email_friend_message');
  
});