extends Sprite

var layer
var map
var data = []
var _dirty = false

func set_layer(layer):
    self.layer = layer
    self.map = self.layer.map
    self.clear()

func get_core():
    return self.map.get_core()

func clear():
    self.data = []
    while(self.data.size() < self.get_core().chunk_size.x * self.get_core().chunk_size.y):
        self.data.push_back(0)

func set_tile(index, gid):
    if(self.data[index] != gid):
        self.data[index] = gid
        self.set_dirty()

func set_dirty():
    if(!self._dirty):
        self._dirty = true
        self.call_deferred("refresh")

func refresh():
    self._dirty = false
    # Redraw
    var chunk_size = self.get_core().chunk_size
    var tile_size = self.get_core().tile_size
    var chunk_image = Image.new()
    chunk_image.create(chunk_size.x * tile_size.x, chunk_size.y * tile_size.y, false, Image.FORMAT_RGBA8)
    var a = 0
    for a in range(self.data.size()):
        var gid = self.data[a]
        if(gid > 0):
            var tile_pos = Vector2(
                int(a) % int(chunk_size.x),
                floor(a / chunk_size.x)
                )
            var ts = self.map.get_tileset(gid)
            var ts_tile_rect = ts.get_tile_rect(gid - ts.first_gid)
            var ts_image = ts.image
            chunk_image.blit_rect(ts_image, ts_tile_rect, Vector2(tile_pos.x * tile_size.x, tile_pos.y * tile_size.y))
    var tex = ImageTexture.new()
    tex.create_from_image(chunk_image, 0)
    self.set_texture(tex)

func get_tile_position(tile_index):
    var tile_pos = self.map.get_tile_position(tile_index)
    var chunk_size = self.get_core().chunk_size
    return Vector2(
        tile_pos.x - (floor(tile_pos.x / chunk_size.x) * chunk_size.x),
        tile_pos.y - (floor(tile_pos.y / chunk_size.y) * chunk_size.y)
        )

func get_tile_index(tile_index):
    var chunk_tile_pos = self.get_tile_position(tile_index)
    var chunk_size = self.get_core().chunk_size
    return chunk_tile_pos.x + chunk_tile_pos.y * chunk_size.x
