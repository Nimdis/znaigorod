@init_form_dialog = (id, title, target, width = 300, height = 'auto') ->
  dialog = $("<div class='" + id + "_form_dialog'/>").dialog
    draggable: false
    height: 'auto'
    modal: true
    position: ['center', 50]
    resizable: false
    title: title
    height: height
    width: width
    open: (evt, ui) ->
      $('body').css('overflow', 'hidden')
    close: (event, ui) ->
      $('body').css('overflow', 'auto')
      $(this).dialog('destroy').remove()

  dialog

init_delete_invitation = (elem) ->
  elem.on 'ajax:success', (evt, response) ->
    target = $(evt.target)
    ul = target.parents('ul')
    target.parents('li').remove()

    unless ul.children().length
      ul.append('<li class="empty">Нет приглашений</li>')

replace_param_value = (url, param, value) ->
  params = {}
  parser = document.createElement('a')
  parser.href = url
  parser.search.replace('?', '').split('&').each (s) ->
    params[s.split('=')[0]] = decodeURIComponent(s.split('=')[1]).replace('+', ' ')
  params[param] = value
  parser.search = "?#{$.param(params, false)}"

  parser

handle_new_invitaion_link = (trgt, response) ->
  dialog = init_form_dialog('invitation', trgt.data('title'), $(trgt.data('target')), 650).html(response)

  handle_inviteables_search_close()
  handle_accounts_search_close()
  handle_close_click()

  $('#invitation_category').change ->
    category = $(this).val()

    link = $('.inviteables_search_open')
    href = replace_param_value(link.attr('href'), 'category', category)
    link.attr('href', href)

    unless $('.inviteables_search_open').is(':visible')
      $('.inviteables_search_open').click()

    link = $('.accounts_search_open')
    href = replace_param_value(link.attr('href'), 'category', category)
    href = replace_param_value(href, 'parent', '')
    link.attr('href', href)

    unless $('.accounts_search_open').is(':visible')
      $('.accounts_search_open').click()

  dialog.on 'ajax:success', (evt, response) ->
    # 1
    if $(response).hasClass('inviteables_search_wrapper')
      $('.forml .info').hide()
      $('.inviteables_search_open').hide()
      $('.inviteables_search_close').show()
      $('.inviteables_search_wrapper').replaceWith(response)
      init_infinite_scroll('.inviteables_search_results_wrapper')

      handle_inviteables_results_search()
      handle_inviteables_search_click()

    # 1
    if $(response).hasClass('accounts_search_wrapper')
      $('.formr .info').hide()
      $('.accounts_search_open').hide()
      $('.accounts_search_close').show()
      $('.accounts_search_wrapper').replaceWith(response)
      init_infinite_scroll('.accounts_search_results_wrapper')

      handle_accounts_results_search()
      handle_accounts_search_filter_links()

    if $(response).hasClass('results')
      target = $(response).data('target')
      $(target).html(response)
      init_infinite_scroll(target, 'update')

    if $(response).is('li')
      $(this).dialog('close')
      li = $(response)
      init_delete_invitation(li)
      trgt.parent().next('.list').find('ul').append(li).find('.empty').remove()

    if $(response).hasClass('social_actions')
      $('.social_actions').replaceWith(response)
      $('.invitation_form_dialog').dialog('close')

    if $(response).hasClass('invitation_status')
      $(evt.target).replaceWith(response)


# КУДА: скрыть
handle_inviteables_search_close = ->
  $('.inviteables_search_close').on 'click', ->
    $('.inviteables_search_close').hide()
    $('.inviteables_search_open').show()
    $('.forml .info').show()
    $('.inviteables_search_wrapper').empty()

    false

# КУДА: выбрать конкретное мероприятие или заведение
handle_inviteables_search_click = ->
  $('.inviteables_search_results_wrapper').on 'click', (evt) ->
    li = $(evt.target).closest('li')
    url = li.data('url')
    $('.new_invitation').attr('action', url)
    $('.search_form').remove()
    $('.selected_result').append(li)
    $('.results', '.inviteables_search_results_wrapper').remove()
    $('.pagination').remove()

    handle_remove_selected_result()

    link = $('.accounts_search_open')
    href = replace_param_value(link.attr('href'), 'parent', li.data('parent'))
    href = replace_param_value(href, 'category', '')
    link.attr('href', href)

    unless $('.accounts_search_open').is(':visible')
      $('.accounts_search_open').click()

    false

# КУДА: закрыть выбранный результат
handle_remove_selected_result = ->
  $('.remove_item').on 'click', ->
    $(this).closest('.selected_result').empty()
    $('.inviteables_search_open').click()

    category = $('#invitation_category').val()
    link = $('.accounts_search_open')
    href = replace_param_value(link.attr('href'), 'parent', '')
    href = replace_param_value(href, 'category', category)
    link.attr('href', href)

    unless $('.accounts_search_open').is(':visible')
      $('.accounts_search_open').click()

    false

# КУДА: поиск по результатам
handle_inviteables_results_search = ->
  $('#inviteables_search_q').keyup ->
    $(this).closest('form').submit()

# КОГО: поиск по результатам
handle_accounts_results_search = ->
  $('#accounts_search_q').keyup ->
    $(this).closest('form').submit()

# КОГО: скрыть
handle_accounts_search_close = ->
  $('.accounts_search_close').on 'click', ->
    $('.accounts_search_close').hide()
    $('.accounts_search_open').show()
    $('.formr .info').show()
    $('.accounts_search_wrapper').empty()

    false

handle_close_click = ->
  $('.cancel', '.invite_form_wrapper').on 'click', ->
    $('.invitation_form_dialog').dialog('close')

    false

handle_accounts_search_filter_links = ->
  $('.filter', '.accounts_search_wrapper').on 'click', (evt) ->
    $(this).children('li').toggleClass('selected not_selected')
    init_infinite_scroll('.accounts_search_results_wrapper', 'update')

@init_invitations = ->
  $('.invitations_wrapper, .content .left').on 'ajax:success', (evt, response) ->
    target = $(evt.target)

    if target.hasClass('change_visit')
      $('.social_actions').replaceWith(response)
    else
      handle_new_invitaion_link(target, response)

  init_delete_invitation $('.delete_invitation')
