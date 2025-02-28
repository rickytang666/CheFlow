/* TIME CLASS */

// Used with Log to keep track of the time, supports comparing and some calculations and formattings
// Some features are not as good as some libraries but it is customized for the streamline of log record operations

class Time
{
  /* FIELDS */

  int year, month, day, hour, minute;

  /* CONSTRUCTOR */

  // overloaded versions: given components, current time, or interpret time format string

  Time(int y, int mo, int d, int h, int mi)
  {
    // using constrain to ensure the values are within the valid range

    year = max(y, 0);
    month = constrain(mo, 1, 12);
    day = constrain(d, 1, days_in_month(month, year));
    hour = constrain(h, 0, 23);
    minute = constrain(mi, 0, 59);
  }

  Time()
  {
    // using the built-in functions to get the current time

    year = year();
    month = month();
    day = day();
    hour = hour();
    minute = minute();
  }

  Time(String time_str) 
  {
    // yyyy-mm-dd hh:mm format

    String[] parts = time_str.split(" ");
    String[] dateParts = parts[0].split("-");
    String[] timeParts = parts[1].split(":");

    year = int(dateParts[0]);
    month = int(dateParts[1]);
    day = int(dateParts[2]);
    hour = int(timeParts[0]);
    minute = int(timeParts[1]);
  }

  /* METHODS */

  String get_time_str()
  {

    // output the time object into yyyy-mm-dd hh:mm format

    return year + "-" + nf(month, 2) + "-" + nf(day, 2) + " " + nf(hour, 2) + ":" + nf(minute, 2);
  }
  
  
  String get_date_str()
  {
    // also output format, but only for date (no hour or minute)

    return year + "-" + nf(month, 2) + "-" + nf(day, 2);
  }
  
  
  Time subtract_days(int days)
  {
    int y = year;
    int mo = month;
    int d = day;

    // subtract the days from the current day
    // if the days exceed the current month, subtract the days from the month
    // if the days exceed the current year, subtract the days from the year

    // keep subtracting until the input finishes the subtraction job, and finally, return the new time object
    
    while (days > 0)
    {
      if (days >= d) // if the days exceed the current month
      {
        // subtract the days from the month and set the days to the last day of the previous month

        days -= d;
        mo--;
        
        if (mo < 1) // if the days exceed the current year
        {
          // if the month is less than 1, set it to 12 and subtract a year
          mo = 12;
          y--;
        }
        
        d = days_in_month(mo, y);
      }
      else
      {
        d -= days;
        days = 0;
      }
    }
    
    return new Time(y, mo, d, hour, minute);
  }


  int to_days() 
  {

    // calculate the total number of days since year 0 for this time object
    // this is used for comparing two time objects (or calculating the difference in days)

    int totalDays = 0;

    // Add days for each year (account for leap years)
    for (int y = 0; y < year; y++) {
        totalDays += (is_leap_year(y) ? 366 : 365);
    }

    // Add days for each month in the current year
    for (int m = 1; m < month; m++) {
        totalDays += days_in_month(m, year);
    }

    // Add the days in the current month
    totalDays += day;

    return totalDays;
  }


  int days_difference(Time other) 
  {
    // Calculate the total number of days since year 0 for both dates

    int thisDays = this.to_days();
    int otherDays = other.to_days();
    
    // Return the difference in days

    return thisDays - otherDays;
  } 

  // implement compareTo method (used for sorting in arrays)

  int compareTo(Time t)
  {
    // compare from year to minute, return the difference in the first different field
    
    if (year != t.year)
    {
      return year - t.year;
    }
    else if (month != t.month)
    {
      return month - t.month;
    }
    else if (day != t.day)
    {
      return day - t.day;
    }
    else if (hour != t.hour)
    {
      return hour - t.hour;
    }
    else
    {
      return minute - t.minute;
    }
  }

}
