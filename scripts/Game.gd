extends Control

var map
var tile_size  = Vector2(16, 16)
var chunk_size = Vector2(16, 16)
var views      = []
var views_node
var base_size = Vector2(384, 288)

func _ready():
    self.views_node = self.get_node("Views")
    self.setup()

    self.load_map("level001.json")
    self.add_view(Rect2(0, 0, self.base_size.x, self.base_size.y))

func setup():
    # Resize window
    OS.set_window_size(Vector2(self.base_size.x, self.base_size.y))
    self.center_window()
    # Set resize callback
    var tree = self.get_tree()
    tree.connect("screen_resized", self, "_screen_resized")

func _input(ev):
    if(ev is InputEventKey):
        if(ev.is_pressed() && ev.get_scancode() == KEY_F4):
            self.toggle_fullscreen()

func toggle_fullscreen():
    OS.set_window_fullscreen(!OS.is_window_fullscreen())

func center_window():
    var screen_size = OS.get_screen_size()
    var window_size = OS.get_window_size()
    OS.set_window_position(Vector2(int(screen_size.x / 2 - window_size.x / 2), int(screen_size.y / 2 - window_size.y / 2)))

func _screen_resized():
    var win_size = OS.get_window_size()
    self.set_size(win_size)
    # Resize background
    var game_bg = self.get_node("ColorRect")
    game_bg.set_size(win_size)
    # Resize views
    var scale = Vector2(
        win_size.x / base_size.x,
        win_size.y / base_size.y
        )
    var pos = Vector2(0, 0)
    if(scale.x > scale.y):
        scale.x = scale.y
        pos.x = floor(win_size.x / 2 - (self.base_size.x * scale.x) / 2)
    elif(scale.x < scale.y):
        scale.y = scale.x
        pos.y = floor(win_size.y / 2 - (self.base_size.y * scale.y) / 2)
    self.views_node.set_position(pos)
    self.views_node.set_scale(scale)

func load_map(url):
    self.map = preload("res://objects/map/Map.tscn").instance()
    self.add_child(self.map)
    self.map.setup("res://assets/maps/" + url)

func add_view(screen_rect):
    var view = preload("res://objects/View.tscn").instance()
    self.views_node.add_child(view)
    self.views.push_back(view)
    view.remove_child(view.sprite)
    self.views_node.add_child(view.sprite)
    view.set_rect(screen_rect)
    view.set_map(self.map)
