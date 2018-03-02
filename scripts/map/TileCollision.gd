extends StaticBody2D

var shape

func _ready():
    self.shape = self.get_node("CollisionShape")

func set_type(type):
    self.clear_shape()
    var new_shape
    if(type == 1):
        new_shape = RectangleShape2D.new()
        new_shape.set_extents(Vector2(8, 8))
        self.shape.set_position(Vector2(8, 8))
        self.shape.set_shape(new_shape)
    elif(type == 2):
        new_shape = ConvexPolygonShape2D.new()
        new_shape.set_points([
            Vector2(0, 16),
            Vector2(16, 0),
            Vector2(16, 16)
            ])
        self.shape.set_position(Vector2(0, 0))
        self.shape.set_shape(new_shape)
    elif(type == 3):
        new_shape = ConvexPolygonShape2D.new()
        new_shape.set_points([
            Vector2(0, 0),
            Vector2(16, 16),
            Vector2(0, 16)
            ])
        self.shape.set_position(Vector2(0, 0))
        self.shape.set_shape(new_shape)
    elif(type == 4):
        new_shape = ConvexPolygonShape2D.new()
        new_shape.set_points([
            Vector2(0, 16),
            Vector2(32, 0),
            Vector2(32, 16)
            ])
        self.shape.set_position(Vector2(0, 0))
        self.shape.set_shape(new_shape)
    elif(type == 6):
        new_shape = ConvexPolygonShape2D.new()
        new_shape.set_points([
            Vector2(0, 0),
            Vector2(32, 16),
            Vector2(0, 16)
            ])
        self.shape.set_position(Vector2(0, 0))
        self.shape.set_shape(new_shape)

func clear_shape():
    self.shape.set_shape(null)
