extends Reference

class_name Constants

# data paths
const CSV_DATA_PATH : String = "data/latent_space_slices/frontend_2d_embeddings_slices.txt"
const CSV_DATA_ROW_SIZE : int = 5
const EMBEDDINGS_CSV_SKIP_HEADER : bool = true

# camera
const CAMERA_PROJECTION_SIZE_MIN : float = 0.0
const CAMERA_PROJECTION_SIZE_MAX : float = 3.0
const CAMERA_LATERAL_MOVEMENT_DAMPING : float = 0.02
const CAMERA_LATERAL_MOVEMENT_MOUSE_TRIGGER_AREA : int = 15
const CAMERA_ZOOM_VELOCITY = 0.3
const CAMERA_FAR : float = 3.0

# lat space visualisation
const EMBEDDINGS_BOUNDING_BOX_MAX_WIDTH : int = 5
const NODES_CONTAINER_SCALE_Z_MIN : float = 0.0
const LATENT_NODES_GROUP_NAME : String = "latent_nodes"
const LATENT_SLICES_GROUP_NAME : String = "latent_slices"
const NODES_CONTAINER_SCALE_Z_MAX : float = 12.0
const LATENT_NODE_MESH_SCALE_MIN : float = 0.005 #
#const LATENT_NODE_MESH_SCALE_MAX : float= 0.3
const LATENT_NODE_COLLISION_SHAPE_SCALE_MIN : float = 0.02
#const LATENT_NODE_COLLISION_SHAPE_SCALE_MAX : float = 0.5
const LATENT_NODES_CIRCLE_MESH_RADIUS: float = 0.1
const LATENT_NODES_CIRCLE_MESH_SEGMENTS: int = 115
const LATENT_NODE_IMAGE_MESH_SCALE : float = 0.1
const LATENT_NODE_SLERP_STEPS : int = 6 # includes steps to create node @ slerp weight 0.0 and 1.0, example: STEPS = 3, will create 1 new lerped point

# visualisation optimisation
const CIRCLE_PACKER_MAX_SPEED : float = LATENT_NODES_CIRCLE_MESH_RADIUS/2.0
const CIRCLE_PACKER_MAX_FORCE : float = LATENT_NODES_CIRCLE_MESH_RADIUS/2.0

# ui
# COLLIDER constants are only useful if using the shape based nodes selector
# it's been replaced with simpler raycast selector 

#const SELECTOR_COLLIDER_SHAPE_XY_SCALE : float = 0.33
#const SELECTOR_COLLIDER_SHAPE_Z_SCALE : float = NODES_CONTAINER_SCALE_Z_MAX/2
#const SELECTOR_COLLIDER_SHAPE_XYZ_EXTENTS : float = 0.205
#const SELECTOR_COLLIDER_DEBUG_BOX_XY : float = 0.061
#const SELECTOR_COLLIDER_DEBUG_BOX_Z : float = NODES_CONTAINER_SCALE_Z_MAX/2

const MOUSE_WHEEL_VELOCITY = 0.1

# back end 
const HOST_IP: String = "127.0.0.1"
const HOST_PORT: int = 5004
const HOST_RECONNECT_TIMEOUT: float = 3.0
const MESSAGE_HEADER_START_DELIMITER : String = "***"
const MESSAGE_KEYVAL_DELIMITER : String = ":"
const MESSAGE_DATA_DELIMITER : String = "###"
const MESSAGE_HEADER_END_DELIMITER : String = "&&&"
const MESSAGE_ARR_DATA_DELIMITER : String = ","
const DEBUG_SHOULD_CONNECT : bool = true
const REQUEST_GENERATE_IMAGES_METADATA : Dictionary = {"request": "generate_images", "data_type": "int_array"}
const REQUEST_GENERATE_SLERPED_IMAGES_METADATA : Dictionary = {"request": "generate_slerped_images", "data_type": "int_array", "slerp_steps": str(LATENT_NODE_SLERP_STEPS)}
const REQUEST_ADD_IMAGES_METADATA : Dictionary = {"request": "add_images", "data_type": "int_array"}
