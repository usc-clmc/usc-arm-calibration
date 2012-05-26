##inertial parameters needed to define a rigid object
float64 mass
geometry_msgs/Vector3 cog

## since it is symmetric we represent only the first 6 elements of the inertia tensor
## in order I11, I12, I13, I22, I23, I33
float64[6] inertia_tensor  
