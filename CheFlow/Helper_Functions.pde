
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


void draw_linear_regression(PApplet appc) {
  int n = daily_durations.size();
  float sumX = 0, sumY = 0, sumXY = 0, sumX2 = 0;

  // Calculate sums for least squares regression
  for (int x = 0; x < n; x++) {
    float y = daily_durations.get(x);
    sumX += x;
    sumY += y;
    sumXY += x * y;
    sumX2 += x * x;
  }

  // Calculate slope (m) and y-intercept (b)
  float m = (n * sumXY - sumX * sumY) / (n * sumX2 - sumX * sumX);
  float b = (sumY - m * sumX) / n;

  // Find the maximum value in daily_durations
  float maxDuration = 0; // Assume non-negative values
  for (float duration : daily_durations) {
    if (duration > maxDuration) {
      maxDuration = duration;
    }
  }

  // Get y-values for the line of best fit
  float yStart = m * 0 + b;       // y-value at x = 0
  float yEnd = m * (n - 1) + b;  // y-value at x = n-1 (364)

  // Map y-values to sketch height (invert y-axis)
  float yStartMapped = appc.map(yStart, 0, maxDuration, appc.height, 0);
  float yEndMapped = appc.map(yEnd, 0, maxDuration, appc.height, 0);

  // Draw the line of best fit
  appc.stroke(255, 0, 0);
  appc.line(0, yStartMapped, appc.width, yEndMapped);
}
