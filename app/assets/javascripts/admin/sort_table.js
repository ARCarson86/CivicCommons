$(document).ready(function(){
  if($('table.people').tablesorter!=undefined) {
    $('table.people').tablesorter();

    var conversation_headers = {};
    conversation_headers[$('th.handle_header').first().index()] = { sorter: false };
    conversation_headers[$('th.actions_header').first().index()] = { sorter: false };
    $('table.conversations.tablesorter').tablesorter({
      headers: conversation_headers,
      sortList: [[1,1]]
    });
  }
});
