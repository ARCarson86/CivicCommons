(function() {

  function authentication_input(name, value) {
    return '<input name="person[authentications_attributes][0]['+name+']" id="person_authentications_attributes_0_'+name+'" value="'+value+'" type="hidden" />';
  }

  var RegistrationPage = {

    submitWithFacebookData: function(data) {
      person = data.person
      person.authentication = person.authentications[0];
      $('#person_first_name').val(person.first_name);
      $('#person_last_name').val(person.last_name);
      $('#person_email').val(person.email);
      $('form#new_person').append(authentication_input('uid', person.authentication.uid));
      $('form#new_person').append(authentication_input('token', person.authentication.token));
      $('form#new_person').append(authentication_input('provider', person.authentication.provider));
      $('form#new_person').trigger('submit');
    }
  }
  this.RegistrationPage = RegistrationPage;
}).call(this);
