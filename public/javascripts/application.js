var SLIDE_SPEED = 500


function jeval(str){return eval('(' +  str + ');'); }



//tog
function tog(clicker, toggler, callback, speed){

  if (speed == undefined)
    speed = SLIDE_SPEED;
  if (callback)
    jQuery(clicker).click(function(){jQuery(toggler).slideToggle(speed, callback); return false;});
  else
    jQuery(clicker).click(function(){jQuery(toggler).slideToggle(speed); return false;});
}


function togger(j, callback, speed){
  if (speed == undefined)
    speed = SLIDE_SPEED;
  if(callback)
  jQuery(j).slideToggle(speed, callback);
  else
  jQuery(j).slideToggle(speed);
}
//tog










//message
function async_message(m, d){message(m, d);}
function messages(m, d){message(m, d);}
function message(message, duration){
    if (duration == undefined){
        duration = 3000;
    }
    if (jQuery.browser.msie) { jQuery("#message").css({position: 'absolute'}); }
    jQuery("#message").text(message).fadeIn(1000);
    setTimeout('jQuery("#message").fadeOut(2000)',duration);
    return false;
}
//message


function debug(m){if (typeof console != 'undefined'){console.log(m);}}
function puts(m){debug(m);}


function thickbox(id, title, height, width){
//    location.href = '/photos/' + id;
//    return;
    if (height == undefined){ height = 300}
    if (width == undefined){ width = 300}
    tb_show(title, '#TB_inline?height='+ height +'&amp;width='+ width +'&amp;inlineId='+ id +'', false);
    return false;
}





function truncate(str, len){
    if (len == undefined){len = 9}

    if (str.length <= len+3){return str;}

    return str.substring(0, len) + '...'
}












function tog_login_element() {
	jQuery('.login_element, .checkout_element').toggle();
}



//start up
jQuery(function(){
  	//waiter
  	jQuery("#waiter").ajaxStart(function(){jQuery(this).show();}).ajaxStop(function(){jQuery(this).hide();}).ajaxError(function(){jQuery(this).hide();});

	jQuery('.jstruncate').truncate({max_length: 50});

	jQuery('#search_q').bind('focus.search_query_field', function(){
		if(jQuery(this).val()=='Search for Friends'){
			jQuery(this).val('');
		}
	});

	jQuery('#search_q').bind('blur.search_query_field', function(){
		if(jQuery(this).val()==''){
			jQuery(this).val('Search for Friends');
		}
	});

});
//start up






function toggleComments(comment_id)
{
	jQuery('#comment_'+comment_id+'_short, #comment_'+comment_id+'_complete').toggleClass('hidden');

	jQuery('#comment_'+comment_id+'_toggle_link').html(
    	jQuery('#comment_'+comment_id+'_toggle_link').html() == "(more)" ? "(less)" : "(more)"
	);
}