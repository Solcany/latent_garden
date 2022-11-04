extends Reference

class_name Mat

static func assign_vertex_albedo_color_material(mesh: MeshInstance):
	var mat = SpatialMaterial.new()
	# use vertex color to color the mesh
	mat.vertex_color_use_as_albedo = true
	mesh.set_surface_material(0, mat)
