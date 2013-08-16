@init_file_upload = () ->
  $('.file_upload').fileupload
    dataType: "script"
    add: (e, data) ->
      file = data.files[0]
      data.context = $(tmpl("template-upload", file))
      $('.upload_wrapper').append(data.context)
      data.submit()
      true
    done: (e, data) ->
      $(data.context).slideUp ->
        $(this).remove()
        true
      init_ajax_delete()
      true
    fail: (e, data) ->
      wrapped = $("<div>" + data.jqXHR.responseText + "</div>")
      wrapped.find('title').remove()
      wrapped.find('style').remove()
      wrapped.find('head').remove()
      console.error wrapped.html().stripTags().unescapeHTML().trim() if console && console.error
      $(data.context).slideUp ->
        $(this).remove()
        true
      init_ajax_delete()
      alert('Oops! Internal Server Error. See console.error for details...')
      true
    start: (e) ->
      $('.upload_wrapper').slideDown()
      true
    stop: (e) ->
      $('.upload_wrapper').slideUp()
      true

  true
