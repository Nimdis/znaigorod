$.fn.add_autosuggest = () ->
  $this = $(this)

  $this.autocomplete
    source: (request, response) ->
      $.ajax
        url: '/organizations.json'
        data: {utf8: 'true', q: request.term}
        success: (data) ->
          response( $.map( data, ( item ) ->
            return {
              id: item.id
              label: item.term
              latitude: item.latitude
              longitude: item.longitude
              value: item.term
            }
          ))
    minLength: 3
    select: ( event, ui ) ->
      target = $('.autosuggest_target', $(event.target).parent().parent())
      target.val(ui.item.id)

@init_autosuggest_handler = () ->
  autosuggest = $('.autosuggest')
  autosuggest.add_autosuggest() if autosuggest.length

  $('form').on('nested:fieldAdded', (event) ->
    $(event.field).find('.autosuggest').filter(':visible').last().add_autosuggest()
  )
