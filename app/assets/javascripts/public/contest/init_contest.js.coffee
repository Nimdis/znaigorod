@init_contest = () ->
  toggler =  $('.content_wrapper .contest .toggler a')
  toggable =  $('.content_wrapper .contest .toggable')
  if toggler.length && toggable.length
    toggler.toggleClass('closed')
    toggler_html = toggler.html()
    toggler.html(toggler_html.add(' &darr;'))
    toggler.click (event) ->
      toggler.toggleClass('closed')
      if toggler.hasClass('closed')
        toggable.slideUp 'fast', ->
          toggler.html(toggler_html.add(' &darr;'))
          true
      else
        toggable.slideDown 'fast', ->
          toggler.html(toggler_html.add(' &uarr;'))
      false

  if typeof VK != 'undefined'
    initialize_vk_likes()
    if $('#vk_contest_work_like').length
      page_title = $('h1', $('#vk_contest_work_like').closest('.content_wrapper')).text().compact() +
        '. ' + $('h2', $('#vk_contest_work_like').closest('.contest .work')).text().compact()
      page_image = $('.image img', $('#vk_contest_work_like').closest('.contest .work')).attr('src').replace(/\/\d+-\d+\//, '/100-63!n/')
      page_description = $('.author', $('#vk_contest_work_like').closest('.contest .work')).text().compact()
      if $('.description', $('#vk_contest_work_like').closest('.contest .work')).length
        page_description += '. ' + $('.description', $('#vk_contest_work_like').closest('.contest .work')).text().compact()
        page_description = page_description.first(137) + '...'
      else
        page_description = page_description.first(140)
      VK.Widgets.Like 'vk_contest_work_like',
        type: 'button'
        height: '20'
        pageTitle: page_title
        pageImage: page_image
        pageDescription: page_description
        text: page_description
    if $('#vk_contest_work_comments').length
      VK.Widgets.Comments 'vk_contest_work_comments'
        limit: '10'
        width: '980'
        attach: '*'

  return true unless $('.content_wrapper nav.pagination').length

  $('.content_wrapper nav.pagination').css
    'height': '0'
    'visibility': 'hidden'

  list_url = window.location.pathname

  list = $('.content_wrapper .contest .works ul')

  first_item = $('li:first', list)
  return true unless first_item.length
  if first_item.siblings().length
    last_item = first_item.siblings().last()
  else
    last_item = first_item

  last_item_top = last_item.position().top
  page = 1
  busy = false

  $(window).scroll ->
    if $(this).scrollTop() + $(this).height() >= last_item_top && !busy
      busy = true
      $.ajax
        url: "#{list_url}?page=#{parseInt(page) + 1}"
        beforeSend: (jqXHR, settings) ->
          $('<li class="ajax_loading_items_indicator">&nbsp;</li>').appendTo(list)
          true
        complete: (jqXHR, textStatus) ->
          $('li.ajax_loading_items_indicator', list).remove()
          true
        success: (data, textStatus, jqXHR) ->
          return true unless data.length
          list.append(data)
          last_item = first_item.siblings().last()
          last_item_top = last_item.position().top
          page += 1
          busy = false
          initialize_vk_likes()
          true
        error: (jqXHR, textStatus, errorThrown) ->
          console.log jqXHR.responseText.strip_tags() if console && console.log
          true
    true
  true

initialize_vk_likes = () ->
  if $('.contest_work_vk_like_on_list').length
    $('.contest_work_vk_like_on_list').each (index, item) ->
      return true if $(this).hasClass('vk_like_initialized')
      VK.Widgets.Like "#{$('div', $(item)).attr('id')}",
        type: 'mini'
        height: '18'
        pageUrl: $(item).attr('data-url')
        pageTitle: $(item).attr('data-title')
        pageImage: $(item).attr('data-image')
        pageDescription: $(item).attr('data-description')
        text: $(item).attr('data-description')
      true
      $(this).addClass('vk_like_initialized')
  true

  if typeof VK != 'undefined'
    if $('#vk_contest_work_like').length
      page_title = $('h1', $('#vk_contest_work_like').closest('.content_wrapper')).text().compact() +
        '. ' + $('h2', $('#vk_contest_work_like').closest('.contest .work')).text().compact()
      page_image = $('.image img', $('#vk_contest_work_like').closest('.contest .work')).attr('src').replace(/\/\d+-\d+\//, '/100-63!n/')
      page_description = $('.author', $('#vk_contest_work_like').closest('.contest .work')).text().compact()
      if $('.description', $('#vk_contest_work_like').closest('.contest .work')).length
        page_description += '. ' + $('.description', $('#vk_contest_work_like').closest('.contest .work')).text().compact()
        page_description = page_description.first(137) + '...'
      else
        page_description = page_description.first(140)
      VK.Widgets.Like 'vk_contest_work_like',
        type: 'button'
        height: '20'
        pageTitle: page_title
        pageImage: page_image
        pageDescription: page_description
        text: page_description
      true
    if $('#vk_contest_work_comments').length
      VK.Widgets.Comments 'vk_contest_work_comments'
        limit: '10'
        width: '980'
        attach: '*'
      true
