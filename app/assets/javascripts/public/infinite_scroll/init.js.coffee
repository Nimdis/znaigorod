@init_infinite_scroll = (element, option = 'new') ->
  list = $(element)

  if option == 'update'
    console.log 'update'
    list.infinitescroll('destroy')
    list.data('infinitescroll', null)
    list.infinitescroll
      behavior: 'local'
      binder: list
      itemSelector: "ul.results"
      maxPage: $('nav.pagination').data('count')
      navSelector: "nav.pagination"
      nextSelector: "nav.pagination span.next a"
      loading:
        finishedMsg: '<em>Поздравляем, вы достигли конца интернета!</em>'
        msgText: '<em>Загрузка следущей страницы</em>'
  else
    console.log 'new'
    list.infinitescroll
      behavior: 'local'
      binder: list
      debug: false
      itemSelector: "#{element} ul.results"
      maxPage: $(element+' nav.pagination').data('count')
      navSelector: "#{element} nav.pagination"
      nextSelector: "#{element} nav.pagination span.next a"
      loading:
        finishedMsg: '<em>Поздравляем, вы достигли конца интернета!</em>'
        msgText: '<em>Загрузка следущей страницы</em>'
