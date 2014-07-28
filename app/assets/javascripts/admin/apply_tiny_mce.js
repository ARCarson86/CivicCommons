/**
 * Function initiates tinymce for the given list of given jquery list of elements
 * @param JqueryListOfElements - string of the format: "#IdOfElement, .ClassOfElement" or any combination in jquery style
 * */

function init_tiny_mce(JqueryListOfElements){
  $(JqueryListOfElements).tinymce({
    // Location of TinyMCE script
    script_url : '/assets/tiny_mce/tiny_mce_src.js',
    mode : "textareas",
    theme : "advanced",

    // General options
    theme : "advanced",
    plugins : "autolink,lists,pagebreak,style,layer,table,save,advhr,advimage,advlink,emotions,iespell,inlinepopups,insertdatetime,preview,media,searchreplace,print,contextmenu,paste,directionality,fullscreen,noneditable,visualchars,nonbreaking,xhtmlxtras,template,advlist",

    // Theme options
    theme_advanced_buttons1 : "newdocument,|,bold,italic,underline,strikethrough,|,justifyleft,justifycenter,justifyright,justifyfull,formatselect,fontsizeselect,|,code,preview,fullscreen,|,help",
    theme_advanced_buttons2 : "cut,copy,paste,pastetext,pasteword,|,undo,redo,|,bullist,numlist,|,outdent,indent,blockquote,sub,sup,|,link,unlink,image,media,advhr,|,cleanup",
    theme_advanced_buttons3 : "",
    theme_advanced_toolbar_location : "top",
    theme_advanced_toolbar_align : "left",
    theme_advanced_statusbar_location : "bottom",
    theme_advanced_resizing : true
  });
}
