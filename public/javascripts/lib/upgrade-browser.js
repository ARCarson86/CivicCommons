jQuery(function ($){
  var i_am_old_ie = false;
  var rejected_browser_upgrade = $.cookie('rejected_browser_upgrade');

  if($.browser.msie && parseInt($.browser.version, 10) < 8){
    i_am_old_ie = true;
  }
  
  var setCookie = function(){
    $.cookie('rejected_browser_upgrade', true);
  }  
  
  var suggestBrowserUpgrade = function(){
    $.colorbox({opacity:0.5, 
        href: '/upgrade-browser.html',
        onClosed: setCookie})
  }
  
  if(i_am_old_ie && !rejected_browser_upgrade) {
     suggestBrowserUpgrade();
  }  
});