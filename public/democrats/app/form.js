$(document).on('can_embed_loaded', function () {  
  $(theForm).submit(function (event) {
    commanderData();
  });
});

replaceThankYou = function (targetHTML) {
  $('div#action_thank_you_text').text(targetHTML);
}
