init_form_dialog = (id, title, target, width = 300) ->
  dialog = $("<div class='" + id + "_form_dialog'/>").dialog
    draggable: false
    height: 'auto'
    modal: true
    position: ['center', 50]
    resizable: false
    title: title
    width: width
    close: (event, ui) ->
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
    params[s.split('=')[0]] = s.split('=')[1]
  params[param] = value
  parser.search = "?#{$.param(params)}"

  parser

handle_new_invitaion_link = (target, response) ->
  dialog = init_form_dialog('invitation', target.data('title'), $(target.data('target')), 650).html(response)

  handle_inviteables_search_close()
  handle_accounts_search_close()

  $('#invitation_category').change ->
    category = $(this).val()
    link = $('.inviteables_search_open')
    href = link.attr('href').replace /category=(.*)/, "category=#{category}"
    link.attr('href', href)

    unless $('.inviteables_search_open').is(':visible')
      $('.inviteables_search_open').click()

    link = $('.accounts_search_open')
    href = replace_param_value(link.attr('href'), 'category', category)
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

      handle_inviteables_results_search()
      handle_inviteables_search_click()

    # 1
    if $(response).hasClass('accounts_search_wrapper')
      $('.formr .info').hide()
      $('.accounts_search_open').hide()
      $('.accounts_search_close').show()
      $('.accounts_search_wrapper').replaceWith(response)

      handle_accounts_results_search()

    if $(response).hasClass('results')
      target = $(response).data('target')
      $(target).html(response)

    if $(response).is('li')
      $(this).dialog('destroy').remove()
      li = $(response)
      init_delete_invitation li
      target.parent().next('.list').find('ul').append(li).find('.empty').remove()

# куда пригласить: скрыть
handle_inviteables_search_close = ->
  $('.inviteables_search_close').on 'click', ->
    $('.inviteables_search_close').hide()
    $('.inviteables_search_open').show()
    $('.forml .info').show()
    $('.inviteables_search_wrapper').empty()

    false

# куда пригласить: уточнить
handle_inviteables_search_click = ->
  $('.inviteables_search_results_wrapper').on 'click', (evt) ->
    li = $(evt.target).closest('li')
    url = li.data('url')
    $('.new_invitation').attr('action', url)
    $('.search_form').remove()
    $('.selected_result').append(li)
    $('.results').remove()
    $('.pagination').remove()

    handle_remove_selected_result()

    link = $('.accounts_search_open')
    href = link.attr('href')
    link.attr('href', href)

    false


# куда пригласть: закрыть выбранный результат
handle_remove_selected_result = ->
  $('.remove_item').on 'click', ->
    $(this).closest('.selected_result').empty()
    $('.inviteables_search_open').click()

    false

# куда пригласить: поиск по результатам
handle_inviteables_results_search = ->
  $('#inviteables_search_q').keyup ->
    $(this).closest('form').submit()


# кого пригласить: поиск по результатам
handle_accounts_results_search = ->
  $('#accounts_search_q').keyup ->
    $(this).closest('form').submit()

# кого пригласить: скрыть
handle_accounts_search_close = ->
  $('.accounts_search_close').on 'click', ->
    $('.accounts_search_close').hide()
    $('.accounts_search_open').show()
    $('.formr .info').show()
    $('.accounts_search_wrapper').empty()

    false

@init_invitations = ->
  $('.invitations_wrapper').on 'ajax:success', (evt, response) ->
    target = $(evt.target)

    if target.hasClass('invitation_link')
      handle_new_invitaion_link(target, response)

    if target.hasClass('inviteables_search')
      handle_inviteable_search()

  init_delete_invitation $('.delete_invitation')
