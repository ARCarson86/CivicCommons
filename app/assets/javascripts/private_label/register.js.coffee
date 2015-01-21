$ ->
  $('a.register-with-email').on 'click', (event) ->
    event.preventDefault()
    $('.register-form').toggleClass 'hide'
    unless $('.register-form').hasClass 'hide'
      $($('.register-form').find('input[type=text]')[0]).focus()
