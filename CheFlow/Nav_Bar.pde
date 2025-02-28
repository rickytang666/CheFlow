
/** NAV BAR CLASS **/

// The nav bar sits at the top of the screen and allows the user to navigate between the different pages

class Nav_Bar
{
  PApplet parent;
  GButton home_button, recipes_button, fridge_button, matching_button, activity_button; // buttons for directory of each page

  Nav_Bar(PApplet p)
  {
    this.parent = p;
  }

  void setup()
  {
    float start_x = 140;

    float spacing = 20;

    float btn_width = (width - start_x - 6 * spacing) / 5.0; // calculate the width of button

    color col = #EBA3FF; // faint pink

    Font font = new Font("Segoe UI SemiBold", Font.PLAIN, 20); // Use a bigger font for the buttons

    // Set up all the buttons for the pages

    home_button = new GButton(parent, start_x + spacing, 5, btn_width, 50, "Home");
    home_button.setFont(font);
    home_button.setLocalColor(3, col);
    home_button.setLocalColor(4, col);
    home_button.setLocalColor(6, #67CBFD); // light blue
    recipes_button = new GButton(parent, start_x + btn_width + 2 * spacing, 5, btn_width, 50, "Recipes");
    recipes_button.setFont(font);
    recipes_button.setLocalColor(3, col);
    recipes_button.setLocalColor(4, col);
    recipes_button.setLocalColor(6, #67CBFD);
    fridge_button = new GButton(parent, start_x + 2 * btn_width + 3 * spacing, 5, btn_width, 50, "Fridge");
    fridge_button.setFont(font);
    fridge_button.setLocalColor(3, col);
    fridge_button.setLocalColor(4, col);
    fridge_button.setLocalColor(6, #67CBFD);
    matching_button = new GButton(parent, start_x + 3 * btn_width + 4 * spacing, 5, btn_width, 50, "Matching");
    matching_button.setFont(font);
    matching_button.setLocalColor(3, col);
    matching_button.setLocalColor(4, col);
    matching_button.setLocalColor(6, #67CBFD);
    activity_button = new GButton(parent, start_x + 4 * btn_width + 5 * spacing, 5, btn_width, 50, "Activity");
    activity_button.setFont(font);
    activity_button.setLocalColor(3, col);
    activity_button.setLocalColor(4, col);
    activity_button.setLocalColor(6, #67CBFD);

    home_button.addEventHandler(parent, "nav_bar_buttons_handler");
    recipes_button.addEventHandler(parent, "nav_bar_buttons_handler");
    fridge_button.addEventHandler(parent, "nav_bar_buttons_handler");
    matching_button.addEventHandler(parent, "nav_bar_buttons_handler");
    activity_button.addEventHandler(parent, "nav_bar_buttons_handler");
  }

  
  void draw()
  {
    // for background of navbar

    fill( #fffcb1); // light yellow
    noStroke();
    rect(0, 0, width, 60);
  }
}

/** GLOBAL FUNCTIONS **/

void switch_page(Page new_page)
{
  // "delete" the current page and set up the new page

  current_Page.die();
  current_Page = new_page;
  current_Page.setup();
}


/** EVENT HANDLERS **/

public void nav_bar_buttons_handler(GButton button, GEvent event)
{

  // This handler is called when any of the navbar buttons are clicked, and switches the page accordingly

  if (event == GEvent.CLICKED)
  {
    if (button == nb.home_button)
    {
      switch_page(hp);
    }
    else if (button == nb.recipes_button)
    {
      switch_page(rp);
    }
    else if (button == nb.fridge_button)
    {
      switch_page(fp);
    }
    else if (button == nb.matching_button)
    {
      switch_page(mp);
    }
    else if (button == nb.activity_button)
    {
      switch_page(ap);
    }
    
  }
}
