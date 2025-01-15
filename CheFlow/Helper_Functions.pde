
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

  // Draw regression

  linear_regression(appc, n, maxDuration, xAxis, yAxis);
  quadratic_regression(appc, n, maxDuration, xAxis, yAxis);
  exponential_regression(appc, n, maxDuration, xAxis, yAxis);
  
}


void linear_regression(PApplet appc, int n, float maxDuration, int xAxis, int yAxis)
{
  // Calculate linear regression

  float[] coefficients = calculate_linear_coefficients(n);

  float slope = coefficients[0];
  float intercept = coefficients[1];

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
}


float[] calculate_linear_coefficients(int n)
{
  float n_data = n;

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

  float m = (n_data * sumXY - sumX * sumY) / (n_data * sumX_squared - sumX * sumX);
  float b = (sumY - m * sumX) / n_data;

  float coefficients[] = {m, b};

  return coefficients;

}


void quadratic_regression(PApplet appc, int n, float max_duration, int xAxis, int y_axis)
{
  // Calculate quadratic regression
  
  float[] coefficients = calculate_quadratic_coefficients(n);
  float a = coefficients[0];
  float b = coefficients[1];
  float c = coefficients[2];
  
  // Draw quadratic regression curve

  appc.stroke(255, 0, 0);
  appc.strokeWeight(1.5);
  appc.noFill();

  for (int i = xAxis; i < appc.width - 50; i++) 
  {
    float x1 = map(i, xAxis, appc.width - 50, 0, n - 1);
    float x2 = map(i + 1, xAxis, appc.width - 50, 0, n - 1);

    float y1 = a * pow(x1, 2) + b * x1 + c;
    float y2 = a * pow(x2, 2) + b * x2 + c;

    float y1_mapped = map(y1, 0, max_duration, y_axis, 50);
    float y2_mapped = map(y2, 0, max_duration, y_axis, 50);

    appc.line(i, y1_mapped, i + 1, y2_mapped);
  }

}


float[] calculate_quadratic_coefficients(int n)
{
  float nData = n;

  int startIndex = daily_durations.size() - n;

  float sumX = 0, sumY = 0, sumX2 = 0, sumX3 = 0, sumX4 = 0, sumXY = 0, sumX2Y = 0;

  for (int i = startIndex; i < daily_durations.size(); ++i) 
  {
    int x = i - startIndex;
    int y = daily_durations.get(i);

    sumX += x;
    sumY += y;
    sumX2 += pow(x, 2);
    sumX3 += pow(x, 3);
    sumX4 += pow(x, 4);
    sumXY += x * y;
    sumX2Y += pow(x, 2) * y;
  }

  float sumXX = sumX2 - pow(sumX, 2) / nData;
  sumXY = sumXY - (sumX * sumY) / nData;
  float sumXX2 = sumX3 - (sumX * sumX2) / nData;
  sumX2Y = sumX2Y - (sumX2 * sumY) / nData;
  float sumX2X2 = sumX4 - pow(sumX2, 2) / nData;

  float a = (sumX2Y * sumXX - sumXY * sumXX2) / (sumXX * sumX2X2 - pow(sumXX2, 2));
  float b = (sumXY * sumX2X2 - sumX2Y * sumXX2) / (sumXX * sumX2X2 - pow(sumXX2, 2));
  float c = (sumY/nData) - (b * sumX/nData) - (a * sumX2/nData);

  float[] coefficients = {a, b, c};

  return coefficients;

}


void exponential_regression(PApplet appc, int n, float maxDuration, int xAxis, int yAxis)
{
  float[] coefficients = calculate_exponential_coefficients(n);

  float m = coefficients[0], b = coefficients[1];

  float a = exp(b);

  appc.stroke(255, 0, 255);
  appc.strokeWeight(1.5);
  appc.noFill();

  for (int i = xAxis; i < appc.width - 50; ++i)
  {
    float x1 = map(i, xAxis, appc.width - 50, 0, n - 1);
    float x2 = map(i + 1, xAxis, appc.width - 50, 0, n - 1);

    float y1 = a * exp(m * x1);
    float y2 = a * exp(m * x2);

    float y1_mapped = map(y1, 0, maxDuration, yAxis, 50);
    float y2_mapped = map(y2, 0, maxDuration, yAxis, 50);

    appc.line(i, y1_mapped, i + 1, y2_mapped);
  }

}


float[] calculate_exponential_coefficients(int n)
{
  int startIndex = daily_durations.size() - n;

  float sumX = 0, sumY = 0, sumXY = 0, sumX2 = 0;
  for (int i = startIndex; i < daily_durations.size(); ++i) 
  {
    float x = i - startIndex;
    float y = daily_durations.get(i);

    if (y <= 0) {
      continue; // Skip non-positive values
    }

    float log_y = log(y); // Transform y to ln(y)

    sumX += x;
    sumY += log_y;
    sumXY += x * log_y;
    sumX2 += x * x;
  }

  // Avoid divide-by-zero errors by adding a check
  float denominator = (n * sumX2 - sumX * sumX);
  if (denominator == 0) {
    println("Error: Denominator in slope calculation is zero.");
    return new float[]{0, 0}; // Return zero coefficients as a fallback
  }

  float slope = (n * sumXY - sumX * sumY) / denominator; // B = slope
  float intercept = (sumY - slope * sumX) / n; // A = intercept

  float[] coefficients = {slope, intercept};

  return coefficients;
}
