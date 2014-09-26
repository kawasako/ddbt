io = require('socket.io')

sio = (server)->
  global.sio = io(server)
  # Connection socket
  global.sio.on "connection", (socket)->
    return
    # console.log "connection user"
    # global.sio.emit("update", "ぷおぷお")
  # Disconnect event
  global.sio.on "disconnect", ()->
    return
    # console.log "disconnect user"

sio.emit = (type, data)->
  global.sio.emit(type, data)
  return

module.exports = sio