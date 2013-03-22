$ ->
  init_date_picker()
  init_datetime_picker()
  init_manipulate_contacts() if $('.organization_show a.new_contact').length
  init_manipulate_manager() if $('.organization_show .left .info .details .manager').length
