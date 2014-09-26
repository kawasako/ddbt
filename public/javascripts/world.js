// Generated by CoffeeScript 1.6.3
(function() {
  var TrafickWorld;

  TrafickWorld = (function() {
    TrafickWorld.prototype.SCREEN_WIDTH = window.innerWidth;

    TrafickWorld.prototype.SCREEN_HEIGHT = window.innerHeight;

    TrafickWorld.prototype.RADIUS = 20;

    TrafickWorld.prototype.RADIUS_SCALE = 1;

    TrafickWorld.prototype.RADIUS_SCALE_MIN = 0.8;

    TrafickWorld.prototype.RADIUS_SCALE_MAX = 1.2;

    TrafickWorld.prototype.QUANTITY = 0;

    TrafickWorld.prototype.canvas = void 0;

    TrafickWorld.prototype.context = void 0;

    TrafickWorld.prototype.particles = void 0;

    TrafickWorld.prototype.mouseX = 100;

    TrafickWorld.prototype.mouseY = 100;

    TrafickWorld.prototype.mouseIsDown = false;

    function TrafickWorld() {
      var _this;
      this.canvas = document.getElementById("world");
      if (this.canvas && this.canvas.getContext) {
        console.log("run");
        _this = this;
        this.context = this.canvas.getContext("2d");
        this.createParticles();
        setInterval(function() {
          return _this.loop();
        }, 30);
      }
      return;
    }

    TrafickWorld.prototype.loop = function() {
      var i, id, lp, particle, _ref;
      this.RADIUS_SCALE = Math.min(this.RADIUS_SCALE, this.RADIUS_SCALE_MAX);
      this.context.fillStyle = "rgba(0,0,0,0.05)";
      this.context.fillRect(0, 0, this.context.canvas.width, this.context.canvas.height);
      i = 0;
      _ref = this.particles;
      for (id in _ref) {
        particle = _ref[id];
        lp = {
          x: particle.position.x,
          y: particle.position.y
        };
        particle.offset.x += particle.speed;
        particle.offset.y += particle.speed;
        particle.position.x = particle.shift.x + Math.cos(i + particle.offset.x) * (particle.orbit * this.RADIUS_SCALE);
        particle.position.y = particle.shift.y + Math.sin(i + particle.offset.y) * (particle.orbit * this.RADIUS_SCALE);
        particle.position.x = Math.max(Math.min(particle.position.x, this.SCREEN_WIDTH), 0);
        particle.position.y = Math.max(Math.min(particle.position.y, this.SCREEN_HEIGHT), 0);
        particle.size += (particle.targetSize - particle.size) * 0.05;
        if (Math.round(particle.size) === Math.round(particle.targetSize)) {
          particle.targetSize = 1 + Math.random() * 7;
        }
        this.context.beginPath();
        this.context.fillStyle = particle.fillColor;
        this.context.strokeStyle = particle.fillColor;
        this.context.lineWidth = particle.size;
        this.context.moveTo(lp.x, lp.y);
        this.context.lineTo(particle.position.x, particle.position.y);
        this.context.stroke();
        this.context.arc(particle.position.x, particle.position.y, particle.size / 2, 0, Math.PI * 2, true);
        this.context.fill();
        i++;
      }
    };

    TrafickWorld.prototype.createParticles = function() {
      var i;
      this.particles = {};
      i = 0;
      while (i < this.QUANTITY) {
        this.createParticle("tekito", "#fff", 300, 300);
        i++;
      }
    };

    TrafickWorld.prototype.createParticle = function(id, color, x, y) {
      var particle;
      particle = {
        size: 1,
        position: {
          x: x,
          y: y
        },
        offset: {
          x: 0,
          y: 0
        },
        shift: {
          x: x,
          y: y
        },
        speed: 0.01 + Math.random() * 0.04,
        targetSize: 1,
        fillColor: color,
        orbit: this.RADIUS * .5 + (this.RADIUS * .5 * Math.random())
      };
      return this.particles[id] = particle;
    };

    return TrafickWorld;

  })();

  window.TW = new TrafickWorld();

}).call(this);
