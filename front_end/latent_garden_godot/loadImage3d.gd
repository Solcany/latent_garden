extends Spatial


var vertices = PoolVector3Array()
var UVs = PoolVector2Array()
var mat = SpatialMaterial.new()
var color = Color(0.0, 1.0, 0.1)

func _ready():

	vertices.push_back(Vector3(0,0,0))
	vertices.push_back(Vector3(0,1,0))
	vertices.push_back(Vector3(1,1,0))
	vertices.push_back(Vector3(1,0,0))
	
	UVs.push_back(Vector2(0,0))
	UVs.push_back(Vector2(0,1))
	UVs.push_back(Vector2(1,1))
	UVs.push_back(Vector2(1,0))

	mat.albedo_color = color

	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLE_FAN)
	st.set_material(mat)

	for v in vertices.size(): 
		st.add_color(color)
		st.add_uv(UVs[v])
		st.add_vertex(vertices[v])

	var mesh : Mesh = st.commit()
	var meshInstance : MeshInstance = MeshInstance.new()
	meshInstance.mesh = mesh
	meshInstance.name = "gg"
	
	self.add_child(meshInstance)
#	$MeshInstance.mesh = tmpMesh
	
func _process(delta):
	#print(delta)
	$gg.rotation = Vector3(0,delta,0)

