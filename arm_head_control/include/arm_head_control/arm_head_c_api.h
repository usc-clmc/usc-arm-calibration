/*
 * arm_head_c_api.h
 *
 *  Created on: Oct 18, 2010
 *      Author: kalakris
 */

#ifndef ARM_HEAD_C_API_H_
#define ARM_HEAD_C_API_H_

#ifdef __cplusplus
extern "C"
{
#endif

/**
 * \brief Opens communication with the ARM head unit.
 * Returns immediately, use the arm_head_wait_for_initialized() function to
 * wait until initialization is complete.
 *
 * \param reset 1 if the device should be reset, 0 if not
 * \return 1 on success, 0 on failure
 */
int arm_head_initialize(int reset, int position_control);

/**
 * \brief Waits until the ARM head is initialized
 * @return 1 if head is successfully initialized, 0 if not
 */
int arm_head_wait_for_initialized();

/**
 * \brief Checks if the head initialization is complete
 * @return 1 if initialization is complete, 0 if not
 */
int arm_head_is_initialized();

/**
 * Sends desired velocities
 */
int arm_head_set_velocities(float* commanded_velocities);

/**
 * Sends desired positions and velocities
 */
int arm_head_set_positions_velocities(float* commanded_positions, float* commanded_velocities);

/**
 * Reads current positions
 */
int arm_head_get_positions_velocities(float* sensed_positions, float* sensed_velocities);

/**
 * Closes communication and frees up memory
 */
int arm_head_destroy();

/**
 * Gets the resolutions of the device
 */
int arm_head_get_resolutions(float* resolutions);

#ifdef __cplusplus
}
#endif

#endif /* ARM_HEAD_C_API_H_ */
