extends Node2D


const imagesRoot : String = "res://images/"
const imageExtension : String = ".jpg"
var imagesFiles : Array = Array()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var dir = Directory.new()
	if dir.open(imagesRoot) == OK: 
		dir.list_dir_begin()
		var fileName = dir.get_next()
		while fileName != "":
			if fileName.ends_with(imageExtension):
				imagesFiles.append(fileName)
			fileName = dir.get_next()	
		if(imagesFiles.size() > 0):
			pass
			#showImages(imagesFiles)
	else:
		print("An error occurred when trying to access the path.")
		
func showImages(imagesPaths : Array) -> void:
	var rng = RandomNumberGenerator.new()	
	for fileName in imagesFiles:
		var sprite : Sprite = Sprite.new() 
		var node : Node2D = Node2D.new()
		var path = imagesRoot + fileName
		var tex : Texture = load(path)
		sprite.set_texture(tex)  
		var posX : int = rng.randi_range(50, 400)
		print(posX)
		var posY : int = rng.randi_range(50, 400)
		node.set_position(Vector2(posX,posY))      
		node.add_child(sprite)
		add_child(node)	         


#var image = Image.new()
#var err = image.load("path/to/the/image.png")
#if err != OK:
	# Failed
#texture = ImageTexture.new()
#texture.create_from_image(image, 0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
