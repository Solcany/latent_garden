extends Spatial

func _ready():
	var tx = $mesh.get_active_material(0).albedo_texture
	var image : Image = tx.get_data()
	image.save_png('res://test.png')
	#print("d")
	#var im_file = File.new()	
	#img_out.open('res://test.jpg', File.WRITE)
	#img_out.store_buffer(tx_bytes)
	#img_out.close()
	
#img_out.store_buffer(ibytes)
#dat_out.store_line(to_json(idat))
#img_out.close()
#dat_out.close()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
