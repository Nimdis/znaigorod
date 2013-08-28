@init_virtual_tour_link = () ->
  block = $('.organization_show .virtual_tour_link').click (event) ->
    box_width = '760px'
    box_height = '700px'
    data = "<h1>#{$('.organization_show .center h1:first').text()}</h1>"
    data += "
      <div id='krpano'>
        <noscript><center>ERROR: Javascript not activated</center></noscript>
        <a href='#{$(this).attr('data-link')}' class='virtual_tour_link'>#{$(this).attr('data-link')}</a>
      </div>
      <div class='ad'>
        <a href='http://tomsk.3dtour.me/' class='3dtourme' rel='nofollow' target='_blank'>
          <img alt='Изготовление и размещение виртуальных туров' height='69' src='/assets/public/3dtour.png' width='740' />
        </a>
      </div>"
    $.colorbox
      height: box_height
      html: data
      opacity: 0.6
      width: box_width
      onComplete: () ->
        init_swfkrpano()
        true

    false

  true
