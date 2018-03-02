extends "res://scripts/entities/Creature.gd"

var jump_peak_time = [0, 30]

func _ready():
    self.type       = "Player"
    self.subtype    = "Erik"
    self.move_speed = 110
    self.jump_power = 80

func user_input():
    .user_input()
    if(Input.is_action_pressed("left") && !Input.is_action_pressed("right")):
        self.accelerate_left()
    if(Input.is_action_pressed("right") && !Input.is_action_pressed("left")):
        self.accelerate_right()
    if(Input.is_action_just_pressed("action1")):
        self.do_jump()

func do_gravity():
    var should_do_gravity = true
    if(self.is_controlled() && self.velocity.y < 0 && self.jump_peak_time[0] < self.jump_peak_time[1] && Input.is_action_pressed("action1")):
        should_do_gravity = false
        self.jump_peak_time[0] += 1
    if(should_do_gravity):
        .do_gravity()

func motion(dt):
    .motion(dt)
    if(self.is_on_floor()):
        self.jump_peak_time[0] = 0

func do_land():
    .do_land()
    self.jump_peak_time[0] = 0

func animate(dt):
    # Turn around sprite
    var sprite_scale = self.sprite.get_scale()
    if((self.move_dir == -1 && sprite_scale.x > 0) || (self.move_dir == 1 && sprite_scale.x < 0)):
        self.sprite.set_scale(Vector2(-sprite_scale.x, sprite.scale.y))
    # Animate
    # On floor
    if(self.on_floor):
        # Push
        if(self.move_dir != 0 && self.test_move(self.get_transform(), Vector2(self.move_dir, 0))):
            if(self.animation.get_current_animation() != "push"):
                self.animation.play("push")
        # Idle
        elif(self.velocity.x == 0 && self.move_dir == 0):
            self.animate_idle()
        # Move
        else:
            self.animation.set_current_animation("move")
            self.animation.set_speed_scale(abs(self.velocity.x / self.move_speed))
    # In the air
    else:
        if(self.velocity.y < -30 && self.animation.get_current_animation() != "jump_rising1"):
            self.animation.play("jump_rising1")
        elif(self.velocity.y >= -30 && self.velocity.y < 30 && self.animation.get_current_animation() != "jump_rising2"):
            self.animation.play("jump_rising2")
        elif(self.velocity.y >= 30 && self.animation.get_current_animation() != "jump_rising3"):
            self.animation.play("jump_rising3")

func animate_idle():
    self.animation.play("idle")
