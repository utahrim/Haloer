// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(document).ready(function(){
	$("#select_all").on("click", function(){
		var checkboxes = $(".check");
		    // check whether checkboxs are selected.
		    if(checkboxes.prop("checked")){
		        // if they are selected,unchecking all the checkbox
		        checkboxes.prop("checked",false);
		    }
		    else {
		        // if they are not selected, checking all the checkbox
		        checkboxes.prop("checked",true);
		    }

	})
});