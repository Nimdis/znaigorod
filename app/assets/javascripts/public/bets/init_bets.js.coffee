@init_bets = () ->
  # afisha#show
  $('.auction').on 'ajax:success', (evt, response, status, jqXHR) ->
    target = $(evt.target)

    # необходима авторизация
    if $('.social_signin_links', $(response)).length
      $('.cloud_wrapper', target.closest('.social_actions')).remove()

      signin_container = $('<div class="sign_in_with" />').appendTo('body').hide().html(response)
      signin_container.dialog
        autoOpen: true
        draggable: false
        modal: true
        resizable: false
        title: 'Необходима авторизация'
        width: '500px'

      init_auth()

      return false

    # в респонсе пришла форма с ошибкой
    if $(response).filter('form').length
      $('.auction form').replaceWith(response)

    # в респонсе пришла ставка
    else
      target.siblings('ul').prepend(response)
      $('.auction form .errors').remove()

@init_bets_payment = () ->
  # my_account#show
  $('.account_messages .bet_actions').on 'ajax:success', (evt, response, status, jqXHR) ->
    return unless $(evt.target).hasClass('bet')

    target = $(evt.target)

    # диалоговое окно покупки билета в личном кабинете (в респонсе пришла форма)
    if $(response).filter('form').length
      container = $('<div class="payment_form_wrapper" />').appendTo('body').hide().html(response)
      form = $('form', container)

      container.dialog
        autoOpen: true
        draggable: false
        modal: true
        resizable: false
        title: 'Форма заказа'
        width: '640px'
        open: ->
          # init_payments.js
          init_actions_handler()
          true
        close: (event, ui) ->
          $(this).dialog('destroy')
          $(this).remove()
          true

    # кнопки принять/отклонить ставку в личном кабинете (в респонсе пришла li.message)
    else
      target.closest('li').replaceWith(response)

