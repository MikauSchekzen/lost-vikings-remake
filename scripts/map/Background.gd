extends ParallaxLayer

var map
var url = ""
var sprite

func _ready():
    self.sprite = self.get_node("Sprite")

func setup(map, url):
    self.map = map
    self.url = url
    var tex = load(self.url)
    self.sprite.set_texture(tex)
    self.reset_scale()

func get_core():
    return self.map.get_core()

func reset_scale():
    var min_size = self.get_core().base_size
    var size = self.sprite.get_texture().get_size()
    var max_width = max(min_size.x, size.x)
    var max_height = max(min_size.y, size.y)
    var min_width = min(min_size.x, size.x)
    var min_height = min(min_size.y, size.y)
    var factor = max(max_width / min_width, max_height / min_height)
    self.sprite.set_scale(Vector2(factor, factor))
