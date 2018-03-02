extends Viewport

var sprite
var camera
var map

func _ready():
    self.sprite = self.get_node("ViewportSprite")
    self.camera = self.get_node("Camera")
    self.camera.set_custom_viewport(self)
    self.camera.make_current()

func set_rect(rect):
    self.sprite.set_position(rect.position)
    self.set_size(rect.size)

func set_map(map):
    if(self.map != map):
        self.map = map
        self.remove_child(self.camera)
        self.map.add_child(self.camera)
        if(self.map.get_parent() is preload("res://scripts/Game.gd")):
            self.map.get_parent().remove_child(self.map)
            self.add_child(self.map)
        self.set_world_2d(self.map.get_world_2d())
