extends Node2D

var core
var collisions  = []
var layers      = []
var tilesets    = []
var backgrounds = []
var size        = Vector2(1, 1)
var url         = ""

func _ready():
    self.core = self.get_node("/root/Game")

func setup(url):
    self.url = url

    var f = File.new()
    f.open(url, File.READ)
    var src = JSON.parse(f.get_as_text()).result
    f.close()

    # Set metadata
    self.size.x = int(src.width)
    self.size.y = int(src.height)
    self.clear_collisions()

    # Add tilesets
    self.setup_tilesets(src.tilesets)

    # Add layers
    self.setup_layers(src.layers)

    # Setup border collisions
    # self.setup_border_collisions()

func get_core():
    return self.core

func setup_tilesets(src):
    var a = 0
    for a in range(src.size()):
        var ts_url = self.url.get_base_dir() + "/" + src[a].source
        var ts = preload("res://scripts/map/Tileset.gd").new(self, ts_url, int(src[a].firstgid))
        self.tilesets.push_back(ts)

func setup_layers(src):
    var a = 0
    for a in range(src.size()):
        var layer_src = src[a]
        if(layer_src.type == "tilelayer"):
            self.setup_tile_layer(layer_src)
        elif(layer_src.type == "imagelayer"):
            self.setup_image_layer(layer_src)
        elif(layer_src.type == "objectgroup"):
            self.setup_object_layer(layer_src)

func setup_tile_layer(src):
    # Create layer
    var layer = preload("res://objects/map/Layer.tscn").instance()
    self.add_child(layer)
    self.layers.push_back(layer)
    # Setup layer
    layer.setup(self, src)
    layer.setup_tile_chunks(src)

func setup_image_layer(src):
    var layer_name = src.name
    var re = RegEx.new()
    # Get background
    re.compile("bg([0-9]+)")
    var result = re.search(layer_name)
    if(result):
        var bg_index = int(result.get_string(0))
        var bg = self.add_background(src.image)
        bg.set_z_index(bg_index)

func setup_object_layer(src):
    var a
    for a in range(src.objects.size()):
        var obj_src = src.objects[a]
        if(obj_src.has("gid")):
            var ts = self.get_tileset(obj_src.gid)
            var tile_props = ts.get_tile_properties(obj_src.gid - ts.first_gid)
            var sprite_props = ts.get_sprite_properties(obj_src.gid - ts.first_gid)
            if(tile_props.has("object")):
                var obj = load("res://objects/" + tile_props.object).instance()
                self.get_node("Objects").add_child(obj)
                obj.set_map(self)
                # Set proper position
                var tiled_size = Vector2(int(sprite_props.imagewidth), int(sprite_props.imageheight))
                var tiled_pos = Vector2(int(obj_src.x), int(obj_src.y))
                obj.set_position(Vector2(tiled_pos.x + floor(tiled_size.x / 2), tiled_pos.y))
                # Handle instance variables
                if(obj_src.has("properties")):
                    var obj_props = obj_src.properties
                    # Setup object
                    if(obj_props.has("setup")):
                        obj.setup(obj_props.setup)

func get_tile_position(index):
    return Vector2(int(index) % int(self.size.x), floor(index / self.size.x))

func get_tile_index(pos):
    return pos.x + pos.y * self.size.x

func get_tileset(gid):
    var a = 0
    for a in range(self.tilesets.size()):
        var ts = self.tilesets[self.tilesets.size() - 1 - a]
        if(gid >= ts.first_gid):
            return ts
    return null

func get_tile_properties(gid):
    var ts = self.get_tileset(gid)
    return ts.get_tile_properties(gid - ts.first_gid)

func clear_collisions():
    # self.collisions = []
    # while(self.collisions.size() < self.size.x * self.size.y):
        # self.collisions.push_back(0)
    while(self.collisions.size() > 0):
        var col = self.collisions.pop_front()
        if(col != null):
            col.get_parent().remove_child(col)
    var a = 0
    for a in range(self.size.x * self.size.y):
        self.collisions.push_back(null)

func set_collision(index, type):
    # self.collisions[index] = type
    var col = preload("res://objects/map/TileCollision.tscn").instance()
    self.get_node("Collisions").add_child(col)
    self.collisions.remove(index)
    self.collisions.insert(index, col)
    var pos = self.get_tile_position(index)
    var tile_size = self.get_core().tile_size
    col.set_position(Vector2(pos.x * tile_size.x, pos.y * tile_size.y))
    if(type > 1):
        col.set_type(type)

func get_tile_collision_at(pos):
    var tile_size = self.get_core().tile_size
    var tile_pos = Vector2(floor(pos.x / tile_size.x), floor(pos.y / tile_size.y))
    var index = self.get_tile_index(tile_pos)
    return self.collisions[index]

func add_background(url):
    var bg = preload("res://objects/map/Background.tscn").instance()
    self.get_node("Backgrounds").add_child(bg)
    self.backgrounds.push_back(bg)
    bg.setup(self, self.url.get_base_dir() + "/" + url)
    return bg

func setup_border_collisions():
    var a
    var col
    var pos
    var tile_size = self.get_core().tile_size
    # for a in range(self.size.x + 2):
        # Top row
        # col = preload("res://objects/map/TileCollision.tscn").instance()
        # self.get_node("Collisions").add_child(col)
        # pos = Vector2((-tile_size.x) + a * tile_size.x, (-tile_size.y))
        # col.set_position(pos)
        # Bottom row
        # col = preload("res://objects/map/TileCollision.tscn").instance()
        # self.get_node("Collisions").add_child(col)
        # pos = Vector2((-tile_size.x) + a * tile_size.x, self.size.y * tile_size.y + tile_size.y)
        # col.set_position(pos)
    for a in range(self.size.y):
        # Left column
        col = preload("res://objects/map/TileCollision.tscn").instance()
        self.get_node("Collisions").add_child(col)
        pos = Vector2((-tile_size.x), a * tile_size.y)
        col.set_position(pos)
        # Right column
        col = preload("res://objects/map/TileCollision.tscn").instance()
        self.get_node("Collisions").add_child(col)
        pos = Vector2(self.size.x * tile_size.x + tile_size.x, a * tile_size.y)
        col.set_position(pos)
