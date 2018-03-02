extends Object

var core
var map
var url               = ""
var image_url         = ""
var first_gid         = 1
var image_width       = 1
var image_height      = 1
var tile_width        = 1
var tile_height       = 1
var padding           = 0
var spacing           = 0
var tile_properties   = {}
var sprite_properties = {}
var type              = "tileset" # Can also be 'spriteset' for collections of images
var image

func _init(map, url, first_gid):
    self.map = map
    self.url = url
    self.first_gid = first_gid
    self.load()

func get_core():
    return self.map.get_core()

func load():
    var f = File.new()
    f.open(self.url, File.READ)
    var src = JSON.parse(f.get_as_text()).result
    f.close()

    # Set metadata
    if(src.has("tiles")):
        self.type = "spriteset"
    if(self.is_tileset()):
        self.image_width = int(src.imagewidth)
        self.image_height = int(src.imageheight)
        self.tile_width = int(src.tilewidth)
        self.tile_height = int(src.tileheight)
        self.padding = int(src.margin)
        self.spacing = int(src.spacing)
        # Load texture
        self.image_url = self.url.get_base_dir() + "/" + src.image
        self.image = Image.new()
        self.image.load(self.image_url)

    # Set tile metadata
    if(src.has("tileproperties")):
        for a in range(src.tileproperties.keys().size()):
            var tile_index = src.tileproperties.keys()[a]
            self.tile_properties[tile_index] = src.tileproperties[tile_index].duplicate()
    if(src.has("tiles")):
        for a in range(src.tiles.keys().size()):
            var tile_index = src.tiles.keys()[a]
            self.sprite_properties[tile_index] = src.tiles[tile_index].duplicate()

func get_size_in_tiles():
    return Vector2(
        (self.image_width - (self.padding * 2) + self.spacing) / (self.tile_width + self.spacing),
        (self.image_height - (self.padding * 2) + self.spacing) / (self.tile_height + self.spacing)
        )

func get_tile_position(index):
    var size_in_tiles = self.get_size_in_tiles()
    return Vector2(int(index) % int(size_in_tiles.x), floor(index / size_in_tiles.x))

func get_tile_index(pos):
    var size_in_tiles = self.get_size_in_tiles()
    return pos.x + pos.y * size_in_tiles.x

func get_tile_rect(index):
    var pos = self.get_tile_position(index)
    return Rect2(
        self.padding + pos.x * (self.tile_width + self.spacing),
        self.padding + pos.y * (self.tile_height + self.spacing),
        self.tile_width,
        self.tile_height
        )

func get_tile_properties(tile_index):
    if(self.tile_properties.has(String(tile_index))):
        return self.tile_properties[String(tile_index)]
    return {}

func get_sprite_properties(tile_index):
    if(!self.is_spriteset()):
        return null
    if(self.sprite_properties.has(String(tile_index))):
        return self.sprite_properties[String(tile_index)]
    return {}

func is_tileset():
    return (self.type == "tileset")

func is_spriteset():
    return (self.type == "spriteset")
