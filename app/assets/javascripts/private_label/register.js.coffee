$ ->
  $('a.register-with-email').on 'click', (event) ->
    event.preventDefault()
    $('.register-form').toggleClass('hide').jump()
    $($('.register-form').find('input[type=text]')[0]).focus() unless $('.register-form').hasClass 'hide'
