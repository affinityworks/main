
function nl2br (str, is_xhtml) {   
    var breakTag = (is_xhtml || typeof is_xhtml === 'undefined') ? '<br />' : '<br>';    
    return (str + '').replace(/([^>\r\n]?)(\r\n|\n\r|\r|\n)/g, '$1'+ breakTag +'$2');
}

$(document).ready(function(){   

//    Handlebars.registerPartial('translate_row', $('#translate_row').html());

    Swag.registerHelpers(window.Handlebars);



    var template = Handlebars.compile($("#groups-template").html());
    $("#content").append(template(data));

    $('[data-toggle="tooltip"]').tooltip(); 



/*   MEMBERS */


    $(".group_members-bulk_tags").hide();
    $( ".group_members-bulk_tags--toggle").click(function() {
        $(".group_members-bulk_tags").toggle();
        return false;
    });

    $(".group_members-bulk_event").hide();
    $( ".group_members-bulk_event--toggle").click(function() {
        $(".group_members-bulk_event").toggle();
        return false;
    });

    $(".group_members-bulk_activity").hide();
    $( ".group_members-bulk_activity--toggle").click(function() {
        $(".group_members-bulk_activity").toggle();
        return false;
    });

    $(".group_members-bulk_score").hide();
    $( ".group_members-bulk_score--toggle").click(function() {
        $(".group_members-bulk_score").toggle();
        return false;
    });
        

    $(".group_member-row-notes").hide();
    $( "#group_member-row-notes--toggle").click(function() {
        $(".group_member-row-notes").toggle();
        return false;
    });








    $( ".group-member-search_form" ).hide();
    $( ".group-member-search_show" ).click(function() {
        $( ".group-member-search_form" ).show();

    });


    $( ".group-member-search_item" ).hide();
    $( ".group-member-search_criteria" ).change(function() {
        $( ".group-member-search_item" ).hide();
        $( ".group-member-search_scope" ).show();

        var criteria = this.value;
        
        $( ".group-member-search_input" ).show();
       $( ".group-member-search_search" ).show();
       $( ".group-member-search_add" ).show();
        

       if (criteria == 'tag') {
            $( ".group-member-search_input" ).show();
           $(".group-member-search_input").attr("placeholder", "Select tag(s)");

       }

       if (criteria =='geo') {
            $( ".group-member-search_geo" ).show();
            $( ".group-member-search_input" ).hide();
            $( ".group-member-search_search" ).hide();
            $( ".group-member-search_add" ).hide();

        }

       if (criteria == 'event') {
           $( ".group-member-search_events" ).show();    
           $( ".group-member-search_event_status" ).show();    
            $( ".group-member-search_add" ).hide();

       }

       if (criteria == 'field') {
           $( ".group-member-search_fields" ).show();    
           $( ".group-member-search_operator" ).show();
           $(".group-member-search_input").attr("placeholder", "Field value");
           
       }


    });

    $( ".group-member-search_geo" ).change(function() {
        var criteria = this.value;
       if (criteria == 'distance') {
                 $( ".group-member-search_geo_distance" ).show();
        }
       if (criteria == 'country') {
            $( ".group-member-search_input" ).show();
            $(".group-member-search_input").attr("placeholder", "select country(s)");
        }
       if (criteria == 'state') {
            $( ".group-member-search_input" ).show();
            $(".group-member-search_input").attr("placeholder", "select state(s)");     
        }
       if (criteria == 'city') {
            $( ".group-member-search_input" ).show();
            $( ".group-member-search_operator" ).show();
            $(".group-member-search_input").attr("placeholder", "select city"); 
        }

       if (criteria == 'point') {
            $( ".group-member-search_geo_distance" ).show();
            $( ".group-member-search_input" ).show();

            $(".group-member-search_input").attr("placeholder", "enter lat/lng"); 
        }
        $( ".group-member-search_search" ).show();
        $( ".group-member-search_add" ).show();

    });



/*   EVENTS */
    

    $( ".group_event-log_new_member_row--add").click(function() {
        $(".group_event-log_new_member_row:last").after($('.group_event-log_new_member_row:last').clone());
        return false;
    });

    $(".group_event-log_new_member").hide();
    $( ".group_event-log_new_member--toggle").click(function() {
        $(".group_event-log_new_member").toggle();
        return false;
    });


    $(".event_list").hide();
    $( ".event_list-toggle").click(function() {
        $(".event_list").toggle();
        return false;
    });

    $(".event_task_list").hide();
    $( ".event_task_list-toggle").click(function() {
        $(".event_task_list").toggle();
        return false;
    });


/* Message  */

     $('#message-content').keyup(function(){
        $('#message-preview-content').html(nl2br(this.value));
    });
     $('#message-subject').keyup(function(){
        $('#message-preview-subject').html(nl2br(this.value));
    });

    $(".group_message-list_body").hide();
    $( ".group_message-list_body--toggle").click(function() {
        $(".group_message-list_body").toggle();
        return false;
    });

// TASKS

    $(".task_rating").hide();
    $( ".task_rating--toggle").click(function() {
        $(".task_rating").toggle();
        return false;
    });

    $(".task_assign").hide();
    $( ".task_assign--toggle").click(function() {
        $(".task_assign").toggle();
        return false;
    });
// PROJECTS

    $(".project_detail").hide();
    $( ".project_detail--toggle").click(function() {
        $(".project_detail").toggle();
        return false;
    });


});   





