@init_infinite_scroll = (element, option = 'new') ->
  list = $(element)
  response_class = element.replace(/_wrapper/, '')

  if option == 'update'
    list.infinitescroll('destroy')
    list.data('infinitescroll', null)
  list.infinitescroll
    behavior: 'local'
    binder: list
    debug: false
    itemSelector: "ul.results.#{response_class}"
    maxPage: $('ul.'+response_class+' + nav.pagination').data('count')
    navSelector: "ul.#{response_class} + nav.pagination"
    nextSelector: "ul.#{response_class} + nav.pagination span.next a"
    loading:
      finishedMsg: '<em>Поздравляем, вы достигли конца интернета!</em>'
      msgText: '<em>Загрузка следущей страницы</em>'
