extends Reference

class_name Constants

const CSV_DATA_PATH : String = "data/latent_space_slices/frontend_2d_embeddings_slices.txt"
const CSV_DATA_ROW_SIZE : int = 5
const EMBEDDINGS_BOUNDING_BOX_MAX_WIDTH : int = 5
const EMBEDDINGS_CSV_SKIP_HEADER : bool = true
const LATENT_NODES_GROUP_NAME : String = "latent_nodes"
const LATENT_SLICES_GROUP_NAME : String = "latent_slices"
const CAMERA_PROJECTION_SIZE_MIN : float = 0.0
const CAMERA_PROJECTION_SIZE_MAX : float = 0.0 # 6.0
const CAMERA_LATERAL_MOVEMENT_DAMPING : float = 0.02
const CAMERA_LATERAL_MOVEMENT_MOUSE_TRIGGER_AREA : int = 15
const CAMERA_FAR : float = 5.0
const NODES_CONTAINER_SCALE_Z_MIN : float = 0.0
const NODES_CONTAINER_SCALE_Z_MAX : float = 6.0
const LATENT_NODE_MESH_SCALE_MIN : float = 0.005 #
#const LATENT_NODE_MESH_SCALE_MAX : float= 0.3
const LATENT_NODE_COLLISION_SHAPE_SCALE_MIN : float = 0.02
#const LATENT_NODE_COLLISION_SHAPE_SCALE_MAX : float = 0.5
const LATENT_NODES_CIRCLE_MESH_RADIUS: float = 0.2
const LATENT_NODES_CIRCLE_MESH_SEGMENTS: int = 10
const LATENT_NODE_IMAGE_MESH_SCALE : float = 0.1
const CIRCLE_PACKER_MAX_SPEED : float = 0.1
const CIRCLE_PACKER_MAX_FORCE : float = 0.1
const SELECTOR_COLLIDER_XY_SCALE : float = LATENT_NODE_COLLISION_SHAPE_SCALE_MIN
const SELECTOR_COLLIDER_Z_SCALE : float = NODES_CONTAINER_SCALE_Z_MAX/2
const HOST_IP: String = "127.0.0.1"
const HOST_PORT: int = 5002
const HOST_RECONNECT_TIMEOUT: float = 3.0
const MESSAGE_HEADER_START_DELIMITER : String = "***"
const MESSAGE_KEYVAL_DELIMITER : String = ":"
const MESSAGE_DATA_DELIMITER : String = "###"
const MESSAGE_HEADER_END_DELIMITER : String = "&&&"
const MESSAGE_ARR_DATA_DELIMITER : String = ","
const DEBUG_SHOULD_CONNECT : bool = true
const REQUEST_GENERATE_IMAGES_METADATA : Dictionary = {"request": "generate_images", "data_type": "int_array"}
const REQUEST_ADD_IMAGES_METADATA : Dictionary = {"request": "add_images", "data_type": "int_array"}
