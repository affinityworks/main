$( document ).ready(function() {
  function selectOrUnselectCheckbox(selector, element){
    selector.prop("checked", false);
    element.prop("checked", true);
  };

  $('.js-email_addresses').on('click', '.js-email-primary:checked', function(event){
    const target = $(event.target);
    selectOrUnselectCheckbox($(".js-email-primary"), target);
  });

  $('.js-phone_numbers').on('click', '.js-phone-primary:checked', function(event){
    const target = $(event.target);
    selectOrUnselectCheckbox($(".js-phone-primary"), target);
  });

});
