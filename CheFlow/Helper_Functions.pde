
Boolean is_recipe_repeated(String name, ArrayList<Recipe> arr)
{
  for (Recipe r : arr)
  {
    if (r.name.equals(name))
    {
      return true;
    }
  }
  
  return false;
}


Boolean is_ingredient_repeated(String name, ArrayList<Ingredient> arr)
{
  for (Ingredient i : arr)
  {
    if (i.name.equals(name))
    {
      return true;
    }
  }

  return false;

}


void sort_recipes(int option)
{
  /*
  1: Sort by id (descending)
  2: Sort by id (ascending)
  3: Sort by name (alphabetical)
  */

  if (option == 1)
  {
    recipes.sort((a, b) -> b.id - a.id);
  }
  else if (option == 2)
  {
    recipes.sort((a, b) -> a.id - b.id);
  }
  else if (option == 3)
  {
    recipes.sort((a, b) -> a.name.compareTo(b.name));
  }
}


ArrayList<Recipe> get_related_recipes(String name)
{
  ArrayList<Recipe> related_recipes = new ArrayList<Recipe>();

  // println("Searching for recipes using ingredient: " + name);
  for (Recipe r : recipes)
  {
    // println("Checking recipe: " + r.name);
    for (Ingredient ing : r.ingredients)
    {
      // println("Checking ingredient: " + ing.name);
      if (ing.name.equals(name))
      {
        // println("Found in recipe: " + r.name);
        related_recipes.add(r);
        break;
      }
    }
  }

  return related_recipes;
}


void fill_search_results(String search)
{
  
  search_results.clear();

  if (search.equals("") || search.equals(" "))
  {
    search_results.addAll(recipes);
  }
  else
  {
    for (Recipe r : recipes)
    {
      if (r.name.toLowerCase().contains(search.toLowerCase()))
      {
        // println("Found recipe: " + r.name);
        search_results.add(r);
      }
      else
      {
        // println(r.name, "does not contain", search);
      }
    }
  }
  
}


color get_color_from_value(float value)
{

  // red-yellow-green color scale, where red is 0, green is 100

  value = constrain(value, 0, 100); // Ensure the value is within the 0-100 range
  
  if (value <= 50) 
  {
    // Interpolate between Red and Yellow
    return lerpColor(color(255, 0, 0), color(255, 255, 0), value / 50.0);
  } else {
    // Interpolate between Yellow and Green
    return lerpColor(color(255, 255, 0), color(0, 255, 0), (value - 50) / 50.0);
  }
  
}


Boolean is_leap_year(int input)
{
  if (input % 4 == 0)
  {
    if (input % 100 == 0)
    {
      if (input % 400 == 0)
      {
        return true;
      }
      return false;
    }
    return true;
  }
  return false;
}


int days_in_month(int month, int year)
{
  if (month == 2)
  {
    if (is_leap_year(year))
    {
      return 29;
    }
    return 28;
  }
  else if (month == 4 || month == 6 || month == 9 || month == 11)
  {
    return 30;
  }
  return 31;
}


int validate_time_str(String timeStr) 
{
  // Split the string into date and time
  String[] parts = timeStr.split(" ");
  if (parts.length != 2) 
  {
    return -1; // Incorrect format (missing space or parts)
  }

  String datePart = parts[0];
  String timePart = parts[1];

  // Validate the date part (YYYY-MM-DD)
  String[] dateParts = datePart.split("-");
  if (dateParts.length != 3) 
  {
    return -1; // Incorrect date format
  }

  try 
  {
    int year = Integer.parseInt(dateParts[0]);
    int month = Integer.parseInt(dateParts[1]);
    int day = Integer.parseInt(dateParts[2]);

    if (month < 1 || month > 12) 
    {
      return -2; // Invalid month
    }

    // Check days in the month
    if (day < 1 || day > days_in_month(month, year)) 
    {
      return -2; // Invalid day
    }
  } 
  catch (NumberFormatException e) 
  {
    return -1; // Date part contains non-numeric values
  }

  // Validate the time part (HH:MM)
  String[] timeParts = timePart.split(":");
  if (timeParts.length != 2) 
  {
    return -1; // Incorrect time format
  }

  try 
  {
    int hour = Integer.parseInt(timeParts[0]);
    int minute = Integer.parseInt(timeParts[1]);

    if (hour < 0 || hour > 23) 
    {
      return -2; // Invalid hour
    }

    if (minute < 0 || minute > 59) 
    {
      return -2; // Invalid minute
    }
  } 
  catch (NumberFormatException e) 
  {
    return -1; // Time part contains non-numeric values
  }

  // Check if the gvien time is later than the current time

  Time current_time = new Time();
  Time given_time = new Time(timeStr);

  if (given_time.compareTo(current_time) > 0) 
  {
    return -3; // Given time is later than the current time
  }

  // All checks passed
  return 0;
}


void sort_log_records()
{
  // From lastest to oldest

  log_records.sort((a, b) -> b.time_finished.compareTo(a.time_finished));
}


float get_average_duration(int days)
{

  float sum = 0.0;

  for (int i = 0; i < days; i++)
  {
    sum += daily_durations.get(i);
  }

  return sum / days;
}


void draw_scatter_plot(PApplet appc, int n) 
{
  // Constrain n between 7 and 365
  n = constrain(n, 7, 365);
  
  float circle_size = map(float(n), 7, 365, 5, 2);

  // Background and axis setup
  appc.background(255);
  appc.stroke(0);
  appc.strokeWeight(1);
  appc.fill(0);

  // Draw axes
  int xAxis = 50; // Left margin
  int yAxis = appc.height - 50; // Bottom margin

  // X-axis
  appc.line(xAxis, yAxis, appc.width - 50, yAxis);
  // Y-axis
  appc.line(xAxis, yAxis, xAxis, 50);

  // Calculate max duration for mapping
  float maxDuration = 0;
  for (int i = daily_durations.size() - n; i < daily_durations.size(); ++i) {
    maxDuration = max(maxDuration, daily_durations.get(i));
  }

  // Draw scatter plot
  appc.fill(0, 0, 255);
  appc.stroke(0, 0, 255);
  appc.strokeWeight(2);
  for (int i = daily_durations.size() - n; i < daily_durations.size(); ++i) {
    float duration = daily_durations.get(i);
    //if (duration == 0) continue;

    float x = map(i - (daily_durations.size() - n), 0, n - 1, xAxis, appc.width - 50);
    float y = map(duration, 0, maxDuration, yAxis, 50);
    appc.circle(x, y, circle_size);
  }

  // Draw linear regression

  linear_regression(appc, n, maxDuration, xAxis, yAxis);
  quadratic_regression(appc, n, maxDuration, xAxis, yAxis);
  
}


void linear_regression(PApplet appc, int n, float maxDuration, int xAxis, int yAxis)
{
  // Calculate linear regression
  float sumX = 0, sumY = 0, sumXY = 0, sumX_squared = 0;
  for (int i = daily_durations.size() - n; i < daily_durations.size(); ++i) 
  {
    float x = i - (daily_durations.size() - n);
    float y = daily_durations.get(i);
    sumX += x;
    sumY += y;
    sumXY += x * y;
    sumX_squared += x * x;
  }

  float slope = (n * sumXY - sumX * sumY) / (n * sumX_squared - sumX * sumX);
  float intercept = (sumY - slope * sumX) / n;

  // Map regression line to canvas
  float yStart = slope * 0 + intercept;
  float yEnd = slope * (n - 1) + intercept;

  float xStartMapped = xAxis;
  float xEndMapped = appc.width - 50;
  float yStartMapped = map(yStart, 0, maxDuration, yAxis, 50);
  float yEndMapped = map(yEnd, 0, maxDuration, yAxis, 50);

  // Draw linear regression line
  appc.stroke(0, 255, 0);
  appc.strokeWeight(1.5);
  appc.line(xStartMapped, yStartMapped, xEndMapped, yEndMapped);

  // println("Slope: ", slope, "Intercept: ", intercept);
}


void quadratic_regression(PApplet appc, int n, float max_duration, int xAxis, int y_axis)
{
  // Calculate quadratic regression

  // float sum_x = 0, sum_y = 0, sum_xx = 0, sum_xy = 0, sum_xx2 = 0, sum_x2x2 = 0, sum_x2y = 0; 
  // for (int i = daily_durations.size() - n; i < daily_durations.size(); ++i) 
  // {
  //   float x = i - (daily_durations.size() - n);
  //   float y = daily_durations.get(i);
  //   sum_x += x;
  //   sum_y += y;
  // }

  // float x_bar = sum_x / n, y_bar = sum_y / n;

  // for (int i = daily_durations.size() - n; i < daily_durations.size(); ++i) 
  // {
  //   float x = i - (daily_durations.size() - n);
  //   float y = daily_durations.get(i);
    
  //   sum_xx += pow((x - x_bar), 2);
  //   sum_xy += (x - x_bar) * (y - y_bar);
  //   sum_xx2 += (x - x_bar) * (pow(x, 2) - pow(x_bar, 2));
  //   sum_x2x2 += pow(x, 2) - pow(x_bar, 2);
  //   sum_x2y += (pow(x, 2) - pow(x_bar, 2)) * (y - y_bar);
  // }

  // float a = (sum_x2y * sum_xx - sum_xy * sum_xx2) / (sum_xx * sum_x2x2 - pow(sum_xx2, 2));
  // float b = (sum_xy * sum_x2x2 - sum_x2y * sum_xx2) / (sum_xx * sum_x2x2 - pow(sum_xx2, 2));
  // float c = y_bar - b * x_bar - a * pow(x_bar, 2);

  int startIndex = daily_durations.size() - n;
  float sumX = 0, sumY = 0, sumX2 = 0, sumX3 = 0, sumX4 = 0, sumXY = 0, sumX2Y = 0;

  for (int i = startIndex; i < daily_durations.size(); ++i) {
    float x = i - startIndex;
    float y = daily_durations.get(i);

    sumX += x;
    sumY += y;
    sumX2 += x * x;
    sumX3 += x * x * x;
    sumX4 += x * x * x * x;
    sumXY += x * y;
    sumX2Y += x * x * y;
  }

  float nData = n;

  // Solving the system of equations to find a, b, c
  float[][] matrix = {
    {nData, sumX, sumX2},
    {sumX, sumX2, sumX3},
    {sumX2, sumX3, sumX4}
  };

  float[] constants = {sumY, sumXY, sumX2Y};

  float[] coefficients = solveLinearSystem(matrix, constants);
  float a = coefficients[2];
  float b = coefficients[1];
  float c = coefficients[0];

  
  // Draw quadratic regression curve

  appc.stroke(255, 0, 0);
  appc.strokeWeight(1.5);
  appc.noFill();

  for (int i = xAxis; i < appc.width - 50; i++) {
    float x1 = map(i, xAxis, appc.width - 50, 0, n - 1);
    float x2 = map(i + 1, xAxis, appc.width - 50, 0, n - 1);

    float y1 = a * pow(x1, 2) + b * x1 + c;
    float y2 = a * pow(x2, 2) + b * x2 + c;

    float y1_mapped = map(y1, 0, max_duration, y_axis, 50);
    float y2_mapped = map(y2, 0, max_duration, y_axis, 50);

    appc.line(i, y1_mapped, i + 1, y2_mapped);
  }

  // println("a: ", a, "b: ", b, "c: ", c);

}


float[] solveLinearSystem(float[][] matrix, float[] constants) {
  int n = matrix.length;

  // Forward elimination
  for (int i = 0; i < n; i++) {
    // Make the diagonal element 1
    float factor = matrix[i][i];
    for (int j = 0; j < n; j++) {
      matrix[i][j] /= factor;
    }
    constants[i] /= factor;

    // Make the rest of the column 0
    for (int k = i + 1; k < n; k++) {
      factor = matrix[k][i];
      for (int j = 0; j < n; j++) {
        matrix[k][j] -= factor * matrix[i][j];
      }
      constants[k] -= factor * constants[i];
    }
  }

  // Back substitution
  float[] solution = new float[n];
  for (int i = n - 1; i >= 0; i--) {
    solution[i] = constants[i];
    for (int j = i + 1; j < n; j++) {
      solution[i] -= matrix[i][j] * solution[j];
    }
  }

  return solution;
}
