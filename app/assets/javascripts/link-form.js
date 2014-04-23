var link = function() {

  var form, urlField, url, issueIdField, conversationIdField;

  var clearHiddenFields = function() {
    issueIdField.val('');
    conversationIdField.val('');
  };

  var handleLinkClick = function(type) {
    return function() {
      var issue = $(this).parents("li");
      issue.append(form);
      form.show();
      clearHiddenFields();
      var idElement = $("#contribution_" + type + "_id");
      idElement.val(issue.attr("data-" + type + "_id")); 
    };
  };

  var setupClosures = function() {
    urlField = $("#contribution_url");
    url = urlField.val();
    issueIdField = $("#contribution_issue_id"); 
    conversationIdField = $("#contribution_conversation_id");
    form = $("#link_form_wrapper").remove();
  };

  var self = {};
  
  self.init = function() {
    setupClosures();
    $("li.attach-issue input.submit").click(handleLinkClick("issue"));
    $("li.attach-conversation input.submit").click(handleLinkClick("conversation"));

    // TODO: this should not be here.
    $(".placeholder").on("click", function() {
      $(this).val("").removeClass("placeholder");
    });
  };
  return self;
}();

$(link.init);
