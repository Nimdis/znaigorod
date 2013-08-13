@init_main_page = () ->

  prepare_affiche_list()

  $(".main_page_affiche .today_in_city_menu ul li a").on "click", (event) ->
    return false if $(this).closest("li").hasClass("current")
    return false if $(".ajax_indicator_wrapper").length
    link = $(this)
    url = link.attr("href")
    $.ajax
      url: url
      beforeSend: (jqXHR, settings) ->
        create_ajax_indicator()
        true
      complete: (jqXHR, textStatus) ->
        remove_ajax_indicator()
        true
      success: (data, textStatus, jqXHR) ->
        $("<div class='ajax_response' />").appendTo("body").hide().html(data)
        $(".main_page_affiche .affiche").animate
          opacity: 0
        , 100, ->
          $(".main_page_affiche .today_in_city_menu").html($(".ajax_response .today_in_city_menu").html())
          $(".main_page_affiche .today_in_city_affiche").html($(".ajax_response .today_in_city_affiche").html())
          $(".main_page_affiche .more_in_city:first .main_page_block").html($(".ajax_response .more_in_city .main_page_block").html())
          $(".ajax_response").remove()
          $(".main_page_affiche .affiche").css
            opacity: 0
          .animate
            opacity: 1
          , 300
          prepare_affiche_list()
          true
        true
      error: (jqXHR, textStatus, errorThrown) ->
        wrapped = $("<div>" + jqXHR.responseText + "</div>")
        wrapped.find('title').remove()
        wrapped.find('style').remove()
        wrapped.find('head').remove()
        console.error wrapped.html().stripTags().unescapeHTML().trim() if console && console.error
        true
    false

  $(".main_page_affiche .was_in_city li").each ->
    li_block = $(this)
    images_block = $(".relative", this)
    $("img", li_block).each (index) ->
      img_width = $(this).outerWidth(true, true)
      img_height = $(this).outerHeight(true, true)
      offset_x = images_block.outerWidth(true,true) / 2 - img_width / 2
      offset_y = images_block.outerHeight(true,true) / 2 - img_height / 2
      switch index
        when 0
          angle = "-12deg"
          offset_x = offset_x - 5
        when 1
          angle = "-5deg"
          offset_x = offset_x - 2
        when 2
          angle = "5deg"
          offset_x = offset_x + 2
        when 3
          angle = "12deg"
          offset_x = offset_x + 5
      $(this).css
        "left": offset_x
        "top": offset_y
        "-webkit-transform": "rotate(#{angle})"
        "-moz-transform": "rotate(#{angle})"
        "-ms-transform": "rotate(#{angle})"
        "-o-transform": "rotate(#{angle})"
        "transform": "rotate(#{angle})"
      $(this).load ->
        img_width = $(this).width()
        img_height = $(this).height()
        offset_x = images_block.outerWidth(true,true) / 2 - img_width / 2
        offset_y = images_block.outerHeight(true,true) / 2 - img_height / 2
        switch index
          when 0
            angle = "-12deg"
            offset_x = offset_x - 5
          when 1
            angle = "-5deg"
            offset_x = offset_x - 2
          when 2
            angle = "5deg"
            offset_x = offset_x + 2
          when 3
            angle = "12deg"
            offset_x = offset_x + 5
        $(this).css
          "left": offset_x
          "top": offset_y
          "-webkit-transform": "rotate(#{angle})"
          "-moz-transform": "rotate(#{angle})"
          "-ms-transform": "rotate(#{angle})"
          "-o-transform": "rotate(#{angle})"
          "transform": "rotate(#{angle})"
        true
      true
    true

  $(".main_page_affiche .was_in_city li img").hover ->
    $("img", $(this).closest("li")).css
      "z-index": 0
    , 200
    $(this).css
      "z-index": 1
    , 100
    true

  true

prepare_affiche_list = ->

  affiches_block = $(".main_page_affiche .affiche")
  list = $("ul", affiches_block)

  $(".ribbon", list).each (index, item) ->
    $(this).closest("li").prependTo(list)
    true

  list_width = 0
  $("li", list).each ->
    list_width += $(this).outerWidth(true, true)
    true
  list.width(list_width)

  if $("li", list).length < 5
    list_height = 0
    $("li", list).each ->
      list_height = $(this).outerHeight(true, true) if  list_height < $(this).outerHeight(true, true)
      true
    list.closest(".affiche")
      .width($("li", list).outerWidth(true, true) * $("li", list).length)
      .height(list_height)
  else
    prev_link = $("<a href='#prev' class='prev disabled'>prev</a>").insertBefore(affiches_block)
    next_link = $("<a href='#next' class='next'>next</a>").insertBefore(affiches_block)
    scroll = $(".main_page_affiche .affiche").jScrollPane
      animateScroll: true
      animateEase: "easeOutCubic"
      animateDuration: 1000
    scroll_api = scroll.data("jsp")
    affiches_block.bind "jsp-scroll-x", (event, scrollPositionX, isAtLeft, isAtRight) ->
      if isAtLeft then prev_link.addClass("disabled") else prev_link.removeClass("disabled")
      if isAtRight then next_link.addClass("disabled") else next_link.removeClass("disabled")
    offset = $("li", list).outerWidth(true, true)
    prev_link.click (event) ->
      return false if $(this).hasClass("disabled")
      scroll_api.scrollByX(-offset * 4)
      false
    next_link.click (event) ->
      return false if $(this).hasClass("disabled")
      scroll_api.scrollByX(offset * 4)
      false

  $(".main_page_affiche .affiche").css("height", "383px") unless list.length

  true

create_ajax_indicator = () ->
  $(".ajax_indicator_wrapper").remove()
  $("<div class='ajax_indicator_wrapper' />").appendTo("body").hide()
  $("<div class='ajax_indicator' />").appendTo(".ajax_indicator_wrapper")
  $("<img width='32' height='32' src='/assets/public/ajax_loader.gif' alt='' />").appendTo(".ajax_indicator")
  $(".ajax_indicator_wrapper").css
    top: $(window).height()/2 - $(".ajax_indicator_wrapper").height()/2 + $(document).scrollTop()
    left: $(window).width()/2 - $(".ajax_indicator_wrapper").width()/2
  .show()
  true

remove_ajax_indicator = () ->
  $(".ajax_indicator_wrapper").remove()
  true
