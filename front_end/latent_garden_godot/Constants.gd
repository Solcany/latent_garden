extends Reference

class_name Constants

const CSV_DATA_PATH : String= "data/latent_space_slices/frontend_2d_embeddings_slices.txt"
const CSV_DATA_ROW_SIZE : int = 5
const EMBEDDINGS_BOUNDING_BOX_MAX_WIDTH : int = 5
const EMBEDDINGS_CSV_SKIP_HEADER : bool = true
const LATENT_NODES_GROUP_NAME : String = "latent_nodes"
const LATENT_SLICES_GROUP_NAME : String = "latent_slices"
const CAMERA_PROJECTION_SIZE_MIN : float = 0.0
const CAMERA_PROJECTION_SIZE_MAX : float = 3.0
const CAMERA_FAR : float = 5.0
const NODES_CONTAINER_SCALE_Z_MIN : float = 0.0
const NODES_CONTAINER_SCALE_Z_MAX : float = 6.0
const LATENT_NODE_MESH_SCALE_MIN : float = 0.01
const LATENT_NODE_MESH_SCALE_MAX : float= 0.3
const LATENT_NODE_COLLISION_SHAPE_SCALE_MIN : float = 0.02
const LATENT_NODE_COLLISION_SHAPE_SCALE_MAX : float = 0.05
#const LATENT_NODE_COLLIDER_SCALE : Vector3 = Vector3(0.1, 0.1, 0.1)
# WIP: collider scale probably should scale with latent space density...
const SELECTOR_COLLIDER_SCALE : Vector3 = Vector3(LATENT_NODE_COLLISION_SHAPE_SCALE_MAX, 
												  LATENT_NODE_COLLISION_SHAPE_SCALE_MAX,
												  NODES_CONTAINER_SCALE_Z_MAX/2)
