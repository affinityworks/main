
$(document).ready(function(){
    $("#btnHide").click(function(){
	    $(":submit").show();
	    $("#btnHide").hide();
	    $(".form_builder_output").hide();
	    $("#form-first_name").show();
	    $("#form-last_name").show();
	    $("#form-email").show();
	    $("#form-zip_code").show();
	           
    });
});
