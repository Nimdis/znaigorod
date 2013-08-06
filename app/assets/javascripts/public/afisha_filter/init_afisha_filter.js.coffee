@init_afisha_filter = () ->

  link = $('.afisha_filters .by_date .daily')
  wrapper = link.closest('li')

  cal = $('<input id="ui-calendar" type="text" />').appendTo('body').datepicker
    showButtonPanel: true
    dateFormat: "yy-mm-dd"
    beforeShow: (input) ->
      console.log '!!!'
      # TODO fix this!!!
      setTimeout (->
        buttonPane = $(input).datepicker('widget').find('.ui-datepicker-buttonpane')
        btn = $("<button class='ui-datepicker-current ui-state-default ui-priority-secondary ui-corner-all' type='button'>Clear</button>")
        btn.unbind("click").bind "click", ->
          $.datepicker._clearDate input
          btn.appendTo buttonPane
      ), 1
    onSelect: (dateText, inst) ->
      link.text("#{inst.selectedDay} #{russian_monthes[inst.selectedMonth]}")
      year = inst.selectedYear
      month = if inst.selectedMonth + 1 < 10 then "0#{inst.selectedMonth + 1}" else inst.selectedMonth + 1
      day = if inst.selectedDay < 10 then "0#{inst.selectedDay}" else inst.selectedDay
      date = "#{year}-#{month}-#{day}"

      search = window.location.search.substring(1)
      object = JSON.parse('{"' + decodeURI(search).replace(/"/g, '\\"').replace(/&/g, '","').replace(/\=/g, '":"') + '"}')
      object.period = 'daily'
      object.on = date
      search = $.param(object)

      window.location.search = "?#{search}"

      true

  search = window.location.search.substring(1)
  object = JSON.parse('{"' + decodeURI(search).replace(/"/g, '\\"').replace(/&/g, '","').replace(/\=/g, '":"') + '"}')
  if object.on
    cal.datepicker('setDate', object.on)
  else
    current_date = new Date
    cal.datepicker('setDate', current_date.toLocaleFormat('%Y-%m-%d'))

  cal.css
    'top': wrapper.position().top
    'left': wrapper.position().left
    'width': wrapper.outerWidth()
    'height': wrapper.outerHeight()

  link.click (event) ->
    if cal.datepicker('widget').is(':hidden')
      cal.datepicker('show')
    else
      cal.datepicker('hide')
    false

  true

@russian_monthes = [
  "января"
  "февраля"
  "марта"
  "апреля"
  "мая"
  "июня"
  "июля"
  "августа"
  "сентября"
  "октября"
  "ноября"
  "декабря"
]
