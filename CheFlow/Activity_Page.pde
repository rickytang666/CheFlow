
/** ACTIVITY PAGE CLASS **/

class Activity_Page extends Page
{
  /* FIELDS */

  ArrayList<GAbstractControl> static_controls = new ArrayList<GAbstractControl>();
  
  GLabel title, page_indicator;
  GImageButton prev_button, next_button, back, add_button, search_button;
  GTextField search_bar, time_editor, duration_editor;

  /* CONSTRUCTORS */

  Activity_Page(PApplet p)
  {
    super(p);
  }

  /* IMPLEMENTED METHODS */

  void setup()
  {
    layer = 0;

    for (int i = 0; i < page_nums.length; ++i)
    {
      page_nums[i] = 0;
    }

    total_page_nums[0] = (int) ceil((float) log_records.size() / buttons_per_page);

    set_nav_gui();
    set_activity_page();

  }


  void die()
  {
    for (GAbstractControl c : static_controls)
    {
      if (c != null)
      {
        c.dispose();
      }
    }

    clear_variable_controls();
  }

  /* ADDITIONAL METHODS */

  void set_nav_gui()
  {

    title = new GLabel(parent, 10, 70, 200, 40, "ACTIVITIES PAGE");
    title.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
    title.setFont(new Font("Inter Display SemiBold Italic", Font.PLAIN, 20));
    title.setTextItalic();
    title.setOpaque(true);
    title.setLocalColor(6, accent_col);
    
    float navButtonY = height - 50;

    prev_button = new GImageButton(parent, width / 2 - 60, navButtonY, button_height, button_height, new String[] {"previous 1.png", "previous 2.png"});
    prev_button.addEventHandler(parent, "handleButtonEvents");

    next_button = new GImageButton(parent, width / 2 + 60, navButtonY, button_height, button_height, new String[] {"next 1.png", "next 2.png"});
    next_button.addEventHandler(parent, "handleButtonEvents");
    
    back = new GImageButton(parent, 20, 150, 60, 60, new String[] {"back button 1.png", "back button 2.png"});
    back.addEventHandler(parent, "handleButtonEvents");

    add_button = new GImageButton(parent, 20, 300, 60, 60, new String[] {"add 1.png", "add 2.png"});
    add_button.addEventHandler(parent, "add_button_handler_log");

    page_indicator = new GLabel(parent, width - 150, navButtonY, 100, button_height);
    page_indicator.setOpaque(true);

    search_bar = new GTextField(parent, 230, 100, 150, 30);
    search_bar.setFont(UI_font);
    
    search_button = new GImageButton(parent, 400, 100, 40, 40, new String[] {"search 1.png", "search 2.png"});
    search_button.addEventHandler(parent, "search_button_handler");

    time_editor = new GTextField(parent, 200, 150, 200, 30);
    time_editor.addEventHandler(parent, "time_editor_handler");
    time_editor.setFont(UI_font);

    duration_editor = new GTextField(parent, 450, 150, 70, 30);
    duration_editor.addEventHandler(parent, "duration_editor_handler");
    duration_editor.setFont(UI_font);
    duration_editor.setNumeric(1, 24 * 60, 1);

    static_controls.add(title);
    static_controls.add(prev_button);
    static_controls.add(next_button);
    static_controls.add(back);
    static_controls.add(add_button);
    static_controls.add(page_indicator);
    static_controls.add(search_bar);
    static_controls.add(search_button);
    static_controls.add(time_editor);
    static_controls.add(duration_editor);
  }


  void update_nav_gui()
  {
    prev_button.setEnabled(page_nums[layer] > 0);
    next_button.setEnabled(page_nums[layer] < total_page_nums[layer] - 1);
    back.setEnabled(layer > 0);
    back.setVisible(layer > 0);
    add_button.setEnabled(layer == 0);
    add_button.setVisible(layer == 0);
    if (layer == 0)
    {
      search_bar.setText("");
    }
    search_bar.setEnabled(layer == 1 && current_log != null);
    search_bar.setVisible(layer == 1 && current_log != null);
    search_button.setEnabled(layer == 1 && current_log != null);
    search_button.setVisible(layer == 1 && current_log != null);
    time_editor.setEnabled(layer == 1 && current_log != null);
    time_editor.setVisible(layer == 1 && current_log != null);
    duration_editor.setEnabled(layer == 1 && current_log != null);
    duration_editor.setVisible(layer == 1 && current_log != null);
  }


  void clear_variable_controls()
  {
    for (Log l : log_records)
    {
      l.dispose_controls();
    }

    for (Recipe r : recipes)
    {
      r.dispose_controls();
    }
  }


  void set_activity_page()
  {
    clear_variable_controls();

    update_nav_gui();

    if (layer == 0)
    {
      sort_log_records();

      total_page_nums[0] = max(1, (int) ceil((float) log_records.size() / buttons_per_page));

      page_indicator.setText("Page " + (page_nums[0] + 1) + " of " + total_page_nums[0]);

      int start = page_nums[0] * buttons_per_page;
      int end = min(log_records.size(), start + buttons_per_page);

      for (int i = start; i < end; ++i)
      {
        Log l  = log_records.get(i);

        int button_index = i - start;
        float x = button_startX;
        float y = button_startY + button_index * (button_height + button_spacing);

        l.button = new GButton(parent, x, y, button_width, button_height, l.time_finished.get_time_str() + " - " + (l.recipe == null ? l.name : l.recipe.name));
        l.button.setLocalColor(3, #48bcb2);
        l.button.setLocalColor(4, #48bcb2);
        l.button.setLocalColor(6, #7995fd);
        l.button.setLocalColor(14, #ff93e0);
        l.button.addEventHandler(parent, "log_button_handler");

        l.del_button = new GImageButton(parent, x + button_width + button_spacing, y, button_height, button_height, new String[] {"delete1.png", "delete2.png"});
        l.del_button.addEventHandler(parent, "log_del_button_handler");

      }
    }
    else if (layer == 1)
    {
      page_indicator.setText("Page " + (page_nums[1] + 1) + " of " + total_page_nums[1]);

      int start = page_nums[1] * buttons_per_page;
      int end = min(search_results.size(), start + buttons_per_page);

      time_editor.setText(current_log.time_finished.get_time_str());
      duration_editor.setText(str(current_log.duration));

      current_log.recipe_label = new GLabel(parent, 550, 100, 200, 30);
      current_log.recipe_label.setOpaque(true);
      String str = "Selected: " + (current_log.recipe == null ? current_log.name : current_log.recipe.name);
      
      current_log.recipe_label.setText(str);
      

      for (int i = start; i < end; ++i)
      {
        Recipe r = search_results.get(i);

        int button_index = i - start;
        float x = button_startX;
        float y = button_startY + button_index * (button_height + button_spacing);

        r.button = new GButton(parent, x, y, button_width, button_height, r.name);
        r.button.setLocalColor(3, accent_col2);
        r.button.setLocalColor(4, accent_col2);
        r.button.setLocalColor(6, #274097);
        r.button.setLocalColor(14, #098d8d);
        r.button.setLocalColor(2, #ffffff);
        r.button.addEventHandler(parent, "recipe_button_handler_log");
      }
    }

  }

}


/* EVENT HANDLERS */

public void log_button_handler(GButton button, GEvent event)
{
  if (event == GEvent.CLICKED)
  {
    for (Log l : log_records)
    {
      if (l.button == button)
      {
        current_log = l;
        layer = 1;
        fill_search_results("");
        total_page_nums[layer] = max(1, (int) ceil((float) search_results.size() / buttons_per_page));
        page_nums[layer] = 0;
        ap.set_activity_page();
        break;
      }
    }
  }
}


public void log_del_button_handler(GImageButton button, GEvent event)
{
  if (event == GEvent.CLICKED)
  {
    for (Log l : log_records)
    {
      if (l.del_button == button)
      {
        l.delete();
        total_page_nums[0] = max(1, (int) ceil((float) log_records.size() / buttons_per_page));
        page_nums[0] = constrain(page_nums[0], 0, total_page_nums[0] - 1);
        ap.set_activity_page();
        break;
      }
    }

    if (auto_save)
    {
      export_data();
    }
  }
}


public void add_button_handler_log(GImageButton button, GEvent event)
{
  if (event == GEvent.CLICKED)
  {
    Log l = new Log();
    log_records.add(0, l);
    total_page_nums[0] = max(1, (int) ceil((float) log_records.size() / buttons_per_page));
    page_nums[0] = 0;
    ap.set_activity_page();

    if (auto_save)
    {
      export_data();
    }
  }
}


public void recipe_button_handler_log(GButton button, GEvent event)
{
  if (event == GEvent.CLICKED)
  {
    for (Recipe r : search_results)
    {
      if (r.button == button)
      {
        current_log.set_recipe(r);
        ap.set_activity_page();
        break;
      }
    }

    if (auto_save)
    {
      export_data();
    }
  }
}


public void time_editor_handler(GTextField source, GEvent event)
{
  if (event == GEvent.CHANGED)
  {
    String time_str = source.getText();

    if (validate_time_str(time_str) == 0)
    {
      Time new_time = new Time(time_str);
      current_log.time_finished = new_time;

      if (auto_save)
      {
        export_data();
      }
    }
  }
}


public void duration_editor_handler(GTextField source, GEvent event)
{
  if (event == GEvent.CHANGED)
  {
    try
    {
      int duration = Integer.parseInt(source.getText());
      current_log.duration = constrain(duration, 1, 24 * 60);

      if (auto_save)
      {
        export_data();
      }
    }
    catch (Exception e)
    {
      
    }
  }
}
