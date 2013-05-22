@init_stream_buro_service = () ->
  jwplayer.key = 'SZeRfk9B2yiaCiIDORB62cYchqlDqQok9qZQCr1qkNg='

  jwplayer('lyube1').setup
    playlist: [
      image: 'http://stream.buro-service.ru/img/innovus3.jpg'
      file: 'http://stream.buro-service.ru/innovus3.m3u8'
    ]
    logo:
      file: "http://stream.buro-service.ru/img/logo.png"
      link: 'http://cam.tom.ru/'
    flashplayer: '/assets/jwplayer.swf'
    width: '640'
    height: '360'
    fallback: false

  jwplayer('lyube2').setup
    playlist: [
      image: 'http://stream.buro-service.ru/img/innovus2.jpg'
      file: 'http://stream.buro-service.ru/innovus2.m3u8'
    ]
    logo:
      file: "http://stream.buro-service.ru/img/logo.png"
      link: 'http://cam.tom.ru/'
    flashplayer: '/assets/jwplayer.swf'
    width: '640'
    height: '360'
    fallback: false

  jwplayer('lyube3').setup
    playlist: [
      image: 'http://stream.buro-service.ru/img/tgr1.jpg'
      file: 'http://stream.buro-service.ru/tgr1.m3u8'
    ]
    logo:
      file: "http://stream.buro-service.ru/img/logo.png"
      link: 'http://cam.tom.ru/'
    flashplayer: '/assets/jwplayer.swf'
    width: '640'
    height: '360'
    fallback: false

  jwplayer('lyube4').setup
    playlist: [
      image: 'http://stream.buro-service.ru/img/innovus4.jpg'
      file: 'http://stream.buro-service.ru/innovus4.m3u8'
    ]
    logo:
      file: "http://stream.buro-service.ru/img/logo.png"
      link: 'http://cam.tom.ru/'
    flashplayer: '/assets/jwplayer.swf'
    width: '640'
    height: '360'
    fallback: false

  true
