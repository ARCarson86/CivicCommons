CKEDITOR.plugins.add('mentions', {
  init: function( editor ) { 
    alert("test");
    //editor.addCommand( 'mentions', { 
    //  exec : function(editor) {
    //    editor.insertHtml( '@' );
    //    var dummyElement = editor.document.createElement( 'img',{
    //      attributes :
    //        {
    //        src : 'null',
    //        width : 0,
    //        height : 0
    //      }
    //    });

    //    editor.insertElement( dummyElement );
    //    var x = 0;
    //    var y  = 0;
    //    var obj = dummyElement.$;
    //    while (obj.offsetParent) {
    //      x += obj.offsetLeft;
    //      y += obj.offsetTop;
    //      obj = obj.offsetParent;
    //    }
    //    x += obj.offsetLeft;
    //    y  += obj.offsetTop;

    //    dummyElement.remove();
    //    editor.contextMenu.show( editor.document.getBody(), null, x, y);
    //  } 
    //});

    //if (editor.contextMenu) { 
    //  editor.addMenuGroup(); 
    //  editor.addMenuItem(); 
    //  editor.contextMenu.addListener(); 
    //} 

  } 

});
