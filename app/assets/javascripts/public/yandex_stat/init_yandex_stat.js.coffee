@init_3dtourme_stat = () ->
  link = $('a.3dtourme')
  link.click (event) ->
    yaCounter14923525.reachGoal('3dtourme') if yaCounter14923525?
    true
  true

@init_prokachkov_stat = () ->
  link = $('a.prokachkov')
  link.click (event) ->
    yaCounter14923525.reachGoal('prokachkov') if yaCounter14923525?
    true
  true

@init_avtovokzal_tomsk_ru_stat = () ->
  link = $('a.avtovokzal_tomsk_ru')
  link.click (event) ->
    yaCounter14923525.reachGoal('avtovokzal_tomsk_ru') if yaCounter14923525?
    true
  true

@init_dobrynin_stat = () ->
  link = $('a.dobrynin')
  link.click (event) ->
    yaCounter14923525.reachGoal('dobrynin') if yaCounter14923525?
    true
  true

@init_skoda_stat = () ->
  link = $('a.skoda')
  link.click (event) ->
    yaCounter14923525.reachGoal('skoda') if yaCounter14923525?
    true
  true

@init_peugeot_stat = () ->
  link = $('a.peugeot')
  link.click (event) ->
    yaCounter14923525.reachGoal('peugeot') if yaCounter14923525?
    true
  true

@init_trodetfond_stat = () ->
  link = $('a.trodetfond')
  link.click (event) ->
    yaCounter14923525.reachGoal('trodetfond') if yaCounter14923525?
    true
  true

@init_tickets_stat = () ->
  link_on_list = $('.tickets_list li a.payment_link')
  link_on_list.click (event) ->
    yaCounter14923525.reachGoal('ticket_on_list') if yaCounter14923525?
    true
  link_on_affiche = $('.affiche .tickets a.payment_link')
  link_on_affiche.click (event) ->
    yaCounter14923525.reachGoal('ticket_on_affiche') if yaCounter14923525?
    true
  true
