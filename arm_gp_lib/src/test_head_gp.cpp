#include <vector>
#include <fstream>
#include <arm_gp_lib/gp_model.h>

using namespace arm_gp_lib;

std::vector<std::vector<double> > loadFileAsMatrix(const std::string& file_name, int num_columns)
{
  std::vector<std::vector<double> > mat;
  std::ifstream f(file_name.c_str());
  if (!f)
  {
    printf("test_gp_model: Couldn't read file %s\n", file_name.c_str());
  }

  std::vector<double> row;
  double val;

  while (f >> val)
  {
    row.push_back(val);
    if (row.size() == num_columns)
    {
      mat.push_back(row);
      row.clear();
    }
  }

  return mat;
}

int main(int argc, char** argv)
{
  GPModel model;
  model.readFromFile("models.txt");

  std::vector<std::vector<double> > inputs = loadFileAsMatrix("correction_gp_input.txt", 4);
  std::vector<std::vector<double> > outputs = loadFileAsMatrix("correction_gp_output.txt", 6);

  printf("Number of test data points: %ld\n", inputs.size());

  for (unsigned int i=0; i<inputs.size(); ++i)
  {
    std::vector<double> pred;
    model.evaluate(inputs[i], pred);
    for (int d=0; d<model.getNumOutputDimensions(); ++d)
    {
      printf("%f (%f)\t", outputs[i][d], pred[d]);
    }
    printf("\n");
  }

  return 0;
}
