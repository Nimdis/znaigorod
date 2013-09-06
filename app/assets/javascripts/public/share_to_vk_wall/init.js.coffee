@init_share_to_vk_wall = (owner_id, message) ->
  console.log 'share'
  #VK.Api.call(
    #'wall.post',
    #{
      #owner_id: owner_id,
      #message: message
    #},
    #(response) ->
      #console.log response
  #)
