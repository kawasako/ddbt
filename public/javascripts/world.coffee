class TrafickWorld
  SCREEN_WIDTH: window.innerWidth
  SCREEN_HEIGHT: window.innerHeight
  RADIUS: 20
  RADIUS_SCALE: 1
  RADIUS_SCALE_MIN: 0.8
  RADIUS_SCALE_MAX: 1.2
  QUANTITY: 0
  canvas: undefined
  context: undefined
  particles: undefined
  mouseX: 100
  mouseY: 100
  mouseIsDown: false

  constructor: ->
    @canvas = document.getElementById("world")
    if @canvas and @canvas.getContext
      console.log "run"
      _this = this;
      @context = @canvas.getContext("2d")
      @createParticles()
      setInterval ->
        _this.loop()
      ,30
    return

  loop: ->
    @RADIUS_SCALE = Math.min(@RADIUS_SCALE, @RADIUS_SCALE_MAX)
    @context.fillStyle = "rgba(0,0,0,0.05)"
    @context.fillRect 0, 0, @context.canvas.width, @context.canvas.height
    i = 0
    for id, particle of @particles
      lp =
        x: particle.position.x
        y: particle.position.y

      # Rotation
      particle.offset.x += particle.speed
      particle.offset.y += particle.speed

      # Follow mouse with some lag
      # particle.shift.x += (@mouseX - particle.shift.x) * (particle.speed)
      # particle.shift.y += (@mouseY - particle.shift.y) * (particle.speed)

      # Apply position
      particle.position.x = particle.shift.x + Math.cos(i + particle.offset.x) * (particle.orbit * @RADIUS_SCALE)
      particle.position.y = particle.shift.y + Math.sin(i + particle.offset.y) * (particle.orbit * @RADIUS_SCALE)

      # Limit to screen bounds
      particle.position.x = Math.max(Math.min(particle.position.x, @SCREEN_WIDTH), 0)
      particle.position.y = Math.max(Math.min(particle.position.y, @SCREEN_HEIGHT), 0)
      particle.size += (particle.targetSize - particle.size) * 0.05
      particle.targetSize = 1 + Math.random() * 7  if Math.round(particle.size) is Math.round(particle.targetSize)
      @context.beginPath()
      @context.fillStyle = particle.fillColor
      @context.strokeStyle = particle.fillColor
      @context.lineWidth = particle.size
      @context.moveTo lp.x, lp.y
      @context.lineTo particle.position.x, particle.position.y
      @context.stroke()
      @context.arc particle.position.x, particle.position.y, particle.size / 2, 0, Math.PI * 2, true
      @context.fill()
      i++
    return

  createParticles: ->
    @particles = {}
    i = 0

    while i < @QUANTITY
      @createParticle("tekito","#fff",300,300)
      i++
    return

  createParticle: (id,color,x,y)->
    particle =
      size: 1
      position:
        x: x
        y: y
      offset:
        x: 0
        y: 0
      shift:
        x: x
        y: y
      speed: 0.01 + Math.random() * 0.04
      targetSize: 1
      fillColor: color
      # fillColor: "#" + (Math.random() * 0x404040 + 0xaaaaaa | 0).toString(16)
      orbit: @RADIUS * .5 + (@RADIUS * .5 * Math.random())

    @particles[id] = particle

window.TW = new TrafickWorld();









