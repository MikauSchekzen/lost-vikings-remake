extends KinematicBody2D

var velocity     = Vector2(0, 0)
var controlled   = false
var type         = "Enemy"
var subtype      = ""
var move_speed   = 20
var jump_power   = 0
var acceleration = 0.05
var deceleration = 0.1
var move_dir     = 0
var max_gravity  = 100
var on_floor     = true
var sprite
var animation
var map

const SIDE_RIGHT  = 0
const SIDE_TOP    = 1
const SIDE_LEFT   = 2
const SIDE_BOTTOM = 3

func _ready():
    self.sprite = self.get_node("Sprite")
    self.animation = self.get_node("Animation")
    pass

func set_map(map):
    self.map = map

func get_core():
    return self.map.get_core()

func _physics_process(dt):
    self.user_input()
    self.animate(dt)
    self.motion(dt)

func user_input():
    pass

func animate(dt):
    pass

func is_controlled():
    return self.controlled

func give_control():
    self.controlled = true

func setup(setup_txt):
    var lines = setup_txt.split("\n")
    var a
    for a in range(lines.size()):
        var line = lines[a]
        var re = RegEx.new()
        var result
        # Set controlled
        re.compile("set_controlled")
        result = re.search(line)
        if(result != null):
            self.give_control()

func motion(dt):
    # Apply gravity
    self.do_gravity()
    var remainder1 = self.move_and_slide(Vector2(self.velocity.x, 0), Vector2(0, -1))
    var remainder2 = self.move_and_slide(Vector2(0, self.velocity.y), Vector2(0, -1))

    # Move
    # var tile_size = self.get_core().tile_size
    # self.set_position(self.get_position() + self.velocity * dt)
    # Floor
    # var pos = self.get_position()
    # var col = self.map.get_tile_collision_at(pos)
    # self.react_to_tile_collision(pos, col, SIDE_BOTTOM)
    # Slope
    # pos = self.get_position() + Vector2(0, -1)
    # col = self.map.get_tile_collision_at(pos)
    # self.react_to_tile_collision(pos, col, SIDE_BOTTOM)
    # Decelerate
    self.decelerate()
    # Set tile flags
    # self.on_floor = self.is_in_tile_solid(self.get_position())
    pass

func do_gravity():
    self.velocity.y = min(self.max_gravity, self.velocity.y + 4)

func do_land():
    pass

func react_to_tile_collision(pos, col, side):
    var diff = self.get_position() - pos
    var tile_size = self.get_core().tile_size
    var base = Vector2(floor(pos.x / tile_size.x) * tile_size.x, floor(pos.y / tile_size.y) * tile_size.y)
    var remainder = Vector2(pos.x - base.x, pos.y - base.y)
    var remainder_ratio = Vector2(remainder.x / tile_size.x, remainder.y / tile_size.y)
    var in_solid_part = self.is_in_tile_solid(pos)
    if(col == 1):
        if(side == SIDE_BOTTOM):
            var tpos = Vector2(pos.x, floor(pos.y / tile_size.y) * tile_size.y)
            tpos += diff
            self.set_position(tpos)
    # Slope UL
    elif(col == 2):
        if(in_solid_part && side == SIDE_BOTTOM):
            var tpos = Vector2(pos.x, base.y + tile_size.y - (remainder_ratio.x * tile_size.y))
            tpos += diff
            self.set_position(tpos)
    # Slope UR
    elif(col == 3):
        if(in_solid_part && side == SIDE_BOTTOM):
            var tpos = Vector2(pos.x, base.y + tile_size.y - ((1 - remainder_ratio.x) * tile_size.y))
            tpos += diff
            self.set_position(tpos)
    # Long slope UL part 1
    elif(col == 4):
        if(in_solid_part && side == SIDE_BOTTOM):
            var tpos = Vector2(pos.x, base.y + tile_size.y - (remainder_ratio.x * 0.5 * tile_size.y))
            tpos += diff
            self.set_position(tpos)
    # Long slope UL part 2
    elif(col == 5):
        if(in_solid_part && side == SIDE_BOTTOM):
            var tpos = Vector2(pos.x, base.y + tile_size.y * 0.5 - ((1 - remainder_ratio.x) * 0.5 * tile_size.y))
            tpos += diff
            self.set_position(tpos)

func is_in_tile_solid(pos):
    var tile_size = self.get_core().tile_size
    var base = Vector2(floor(pos.x / tile_size.x) * tile_size.x, floor(pos.y / tile_size.y) * tile_size.y)
    var remainder = Vector2(pos.x - base.x, pos.y - base.y)
    var col = self.map.get_tile_collision_at(pos)
    # Full solid
    if(col == 1):
        return true
    # Slope UL
    elif(col == 2):
        return (remainder.x + 1 >= tile_size.y - remainder.y)
    # Slope UR
    elif(col == 3):
        return (remainder.x - 1 <= remainder.y)
    # Long slope UL part 1
    elif(col == 4):
        return (remainder.x + 0.5 >= tile_size.y - remainder.y * 0.5)
    # Long slope UL part 2
    elif(col == 5):
        return (remainder.x + 0.5 >= tile_size.y * 0.5 - remainder.y * 0.5)
    return false

func accelerate_left():
    self.velocity.x = max(-self.move_speed, self.velocity.x - self.move_speed * self.acceleration)
    self.move_dir = -1

func accelerate_right():
    self.velocity.x = min(self.move_speed, self.velocity.x + self.move_speed * self.acceleration)
    self.move_dir = 1

func decelerate():
    if(self.velocity.x < 0 && self.move_dir != -1):
        self.velocity.x = min(0, self.velocity.x + self.move_speed * self.deceleration)
    elif(self.velocity.x > 0 && self.move_dir != 1):
        self.velocity.x = max(0, self.velocity.x - self.move_speed * self.deceleration)
    self.move_dir = 0

func do_jump(power=-1):
    if(power == -1):
        power = self.jump_power
    self.velocity.y = -power
