# message containing the pressure information

# Standard ROS header
Header header

# each an array of 24 touch values
int32 NUM_PRESSURE_CELLS_PER_ARRAY=24

# each an array of 24 touch values
float64[24] palm
float64[24] right_finger
float64[24] middle_finger
float64[24] left_finger

