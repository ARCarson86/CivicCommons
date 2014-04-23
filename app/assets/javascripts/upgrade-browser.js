jQuery(function ($){
  var i_am_old_ie = false;
  var rejected_browser_upgrade = $.cookie('rejected_browser_upgrade');

  if((navigator.appName == 'Microsoft Internet Explorer') && parseInt($.browser.version, 10) < 9){
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
