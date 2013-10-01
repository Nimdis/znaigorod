@init_infinite_scroll = (element) ->
  $(element).infinitescroll
    behavior: 'local'
    binder: $(element)
    debug: false
    itemSelector: element + ' ul.results'
    maxPage: $(element+'nav.pagination').data('count')
    navSelector: element + ' nav.pagination'
    nextSelector: element + ' nav.pagination span.next a'
    loading:
      finishedMsg: '<em>Поздравляем, вы достигли конца интернета!</em>'
      msgText: '<em>Загрузка следущей страницы</em>'
