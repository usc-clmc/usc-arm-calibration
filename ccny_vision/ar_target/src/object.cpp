/* 
 ** ARToolKit object parsing function
 **   - reads in object data from object file in Data/object_data
 **
 ** Format:
 ** <obj_num>
 **
 ** <obj_pattern filename>
 ** <marker_width>
 ** <centerX centerY>
 **
 ** ...
 **
 **	eg
 **
 **	#pattern 1
 **	Data/hiroPatt
 **	80.0
 **	0.0 0.0
 **
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <AR/ar.h>
#include <ros/ros.h>
#include <ros/package.h>

#include <usc_utilities/assert.h>

#include <ar_target/object.h>

namespace ar_object
{

static char *get_buff(char *buf,
                      int n,
                      FILE * fp);

ObjectData_T *read_ObjData(char *name,
                           int *objectnum)
{
  FILE *fp;
  ObjectData_T *object;
  char buf[256], buf1[256];
  int i;
  std::string package_path = ros::package::getPath(ROS_PACKAGE_NAME);

  ROS_DEBUG("Opening Data File %s", name);
  ROS_ASSERT_MSG((fp = fopen(name, "r")) != NULL, "Could not open file >%s<.", name);

  get_buff(buf, 256, fp);
  if (sscanf(buf, "%d", objectnum) != 1)
  {
    fclose(fp);
    ROS_BREAK ();
  }

  ROS_DEBUG("About to load %d Models", *objectnum);

  object = (ObjectData_T *)malloc(sizeof(ObjectData_T) * (*objectnum));
  if (object == NULL)
  {
    ROS_ASSERT_MSG(false, "Could not allocate memory for >%i< patterns.", *objectnum);
  }

  for (i = 0; i < *objectnum; i++)
  {
    object[i].visible = 0;
    object[i].marker_center[0] = 0.0;
    object[i].marker_center[1] = 0.0;

    ROS_DEBUG("Read in No.%d", i + 1);

    get_buff(buf, 256, fp);
    if (sscanf(buf, "%s", buf1) != 1)
    {
      fclose(fp);
      free(object);
      ROS_ASSERT_MSG(false, "Problems when reading pattern file >%s<.", buf);
    }

    sprintf(buf, "%s/%s", package_path.c_str(), buf1);
    if ((object[i].id = arLoadPatt(buf)) < 0)
    {
      fclose(fp);
      free(object);
      ROS_ASSERT_MSG(false, "Could not load pattern >%s<.", buf);
    }

    get_buff(buf, 256, fp);
    if (sscanf(buf, "%lf", &object[i].marker_width) != 1)
    {
      fclose(fp);
      free(object);
      ROS_ASSERT_MSG(false, "Could not read marker width in file >%s<.", buf);
    }
  }

  fclose(fp);
  return object;
}

static char *get_buff(char *buf,
                      int n,
                      FILE * fp)
{
  char *ret;

  for (;;)
  {
    ret = fgets(buf, n, fp);
    if (ret == NULL)
      return (NULL);
    if (buf[0] != '\n' && buf[0] != '#')
      return (ret);
  }
}
}
