@init_common = () ->

  $('a.disabled, .disabled > a').live 'click', (event) ->
    event.preventDefault()
    false

  $('.ui-widget-overlay').live 'click', (event) ->
    $(this).siblings('.ui-dialog').find('.ui-dialog-content').dialog('close')
    true

  $(document).click ->
    $(".need_close_by_click").removeClass('need_close_by_click').hide()
    true

  true

randomize = (number) ->
  Math.floor(Math.random() * Math.round(number) + 1)

String.prototype.trim = () ->
  this.replace(/^\s+|\s+$/g, "")

String.prototype.squish = () ->
  this.replace(/\s+/g, " ").trim()

String.prototype.strip_tags = () ->
  this.replace(/(<([^>]+)>)/ig, "").replace(/&\w+;/ig, " ").replace(/&#?[a-z0-9]+;/ig, "")

Date::toLocaleFormat = (format) ->
  f =
    Y: @getYear() + 1900
    m: @getMonth() + 1
    d: @getDate()
    H: @getHours()
    M: @getMinutes()
    S: @getSeconds()

  for k of f
    format = format.replace("%" + k, (if f[k] < 10 then "0" + f[k] else f[k]))
  format
