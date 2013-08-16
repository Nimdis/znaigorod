next_page_handler = () ->
  $('.next_page').on 'ajax:success', (evt, response) ->
    target = $(evt.target)
    paginator = target.closest('.pagination')
    paginator.closest('ul').append(response)
    target.closest('.pagination').remove()

@init_next_page_pagination = () ->
  $('.next_page').live 'click', ->
    next_page_handler()
