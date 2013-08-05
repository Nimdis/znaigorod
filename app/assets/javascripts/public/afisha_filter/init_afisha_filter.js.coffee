@init_afisha_filter = () ->

  link = $($('.affiches_filter .periods .daily, .navigation .periods .daily').children()[0])
  wrapper = link.closest('li')

  cal = $('<input id="ui-calendar" type="text" />').appendTo('body').datepicker
    dateFormat: "yy-mm-dd"
    onSelect: (dateText, inst) ->
      link.text("#{inst.selectedDay} #{russian_monthes[inst.selectedMonth]}")
      year = inst.selectedYear
      month = if inst.selectedMonth + 1 < 10 then "0#{inst.selectedMonth + 1}" else inst.selectedMonth + 1
      day = if inst.selectedDay < 10 then "0#{inst.selectedDay}" else inst.selectedDay
      date = "#{year}-#{month}-#{day}"

      location = window.location.pathname
      if location.match(/\d{4}-\d{1,2}-\d{1,2}/)
        location = location.replace(/\d{4}-\d{1,2}-\d{1,2}/, date)
      else if location.match(/daily/)
        cal.datepicker('setDate', date)
        location = location.replace(/daily/, "daily/#{date}")
      else
        for key, value of ["today", "weekly", "weekend", "all"]
          location = location.replace("#{value}", "daily/#{date}") if location.match("#{value}")
      window.location.pathname = location

      true

  location = window.location.pathname
  if location.match(/\d{4}-\d{1,2}-\d{1,2}/)
    cal.datepicker('setDate', location.match(/\d{4}-\d{1,2}-\d{1,2}/)[0])
  else if location.match(/daily/)
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
