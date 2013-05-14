$ ->
  init_date_picker()
  init_datetime_picker()
  init_manipulate_contacts() if $('.organization_show a.new_contact').length
  init_manipulate_additional() if $('.organization_show .left .info .details .additional').length
  init_manipulate_activities() if $('.organization_show .left .activities a.new_activity').length
  init_manipulate_slave_organizations()

  $(document).ajaxError (event, jqXHR, ajaxSettings, thrownError) ->
    wrapped = $("<div>" + jqXHR.responseText + "</div>")
    wrapped.find('title').remove()
    wrapped.find('style').remove()
    wrapped.find('head').remove()
    console.error wrapped.html().stripTags().unescapeHTML().trim() if console && console.error
    true
