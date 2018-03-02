extends Node2D

var map
var chunks = []
var layer_name = ""

func setup(map, src):
    self.map = map
    self.layer_name = src.name

func setup_tile_chunks(src):
    var chunk_size = self.get_core().chunk_size
    var tile_size = self.get_core().tile_size
    # Initialize chunks
    var a = 0
    var b = 0
    for b in range(ceil(self.map.size.y / chunk_size.y)):
        for a in range(ceil(self.map.size.x / chunk_size.x)):
            var chunk = preload("res://objects/map/TileChunk.tscn").instance()
            self.add_child(chunk)
            self.chunks.push_back(chunk)
            chunk.set_layer(self)
            chunk.set_position(Vector2(
                chunk_size.x * tile_size.x * a,
                chunk_size.y * tile_size.y * b
                ))
    # Determine chunks
    for a in range(src.data.size()):
        var gid = src.data[a]
        if(gid > 0):
            self.set_tile(a, gid)

func get_core():
    return self.map.get_core()

func create_empty_chunk_data():
    var data = []
    var chunk_size = self.get_core().chunk_size
    while(data.size() < chunk_size.x * chunk_size.y):
        data.push_back(0)
    return data

func get_chunk_position(tile_index):
    var chunk_size = self.get_core().chunk_size
    var tile_pos = self.map.get_tile_position(tile_index)
    return Vector2(floor(tile_pos.x / chunk_size.x), floor(tile_pos.y / chunk_size.y))

func get_chunk_index(tile_index):
    var chunk_size = self.get_core().chunk_size
    var chunk_cols = ceil(self.map.size.x / chunk_size.x)
    var chunk_pos = self.get_chunk_position(tile_index)
    return chunk_pos.x + chunk_pos.y * chunk_cols

func set_tile(index, gid):
    var chunk_index = self.get_chunk_index(index)
    var chunk = self.chunks[chunk_index]
    var chunk_tile_index = chunk.get_tile_index(index)
    chunk.set_tile(chunk_tile_index, gid)
    var should_set_collision = (self.layer_name == "tiles")
    if(should_set_collision):
        var ts = self.map.get_tileset(gid)
        if(ts == null):
            self.set_collision(index, 0)
        else:
            var props = ts.get_tile_properties(gid - ts.first_gid)
            if(props.has("tile_mask")):
                self.set_collision(index, int(props["tile_mask"]))

func set_collision(index, type):
    self.map.set_collision(index, type)
