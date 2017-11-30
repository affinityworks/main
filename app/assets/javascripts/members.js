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

  $(".phone-input").on("input", function (e) {
    const val = e.currentTarget.value
    switch (val) {
      case "+":
        $(this).mask("+9-999-999-9999");
        break;
      case "(":
        $(this).mask("(999) 999-9999");
        break;
    }
  })
});
