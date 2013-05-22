@init_stream_buro_service = () ->
  jwplayer.key = 'SZeRfk9B2yiaCiIDORB62cYchqlDqQok9qZQCr1qkNg='

  jwplayer('lyube').setup
    playlist: [
      image: 'http://stream.buro-service.ru/img/tgr1.jpg'
      file: 'http://stream.buro-service.ru/tgr1.m3u8'
    ]
    logo:
      file: "http://stream.buro-service.ru/img/logo.png"
      link: 'http://cam.tom.ru/'
    autostart: true
    flashplayer: '/assets/jwplayer.swf'
    width: '640'
    height: '360'
    fallback: false

  true
