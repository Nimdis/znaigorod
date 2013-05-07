@init_visits = () ->
  $(".checkable").on "click", ->
    $(this).closest('form').submit()

    $(".ajaxed").on "ajax:success", (evt, response, status, jqXHR) ->
      target = $(evt.target).siblings('.visitors')
      target.html(jqXHR.responseText)

