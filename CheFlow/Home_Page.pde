
/** HOME PAGE CLASS **/

class Home_Page extends Page
{
  /* FIELDS */

  ArrayList<GAbstractControl> static_controls = new ArrayList<GAbstractControl>();
  GLabel title, insights;
  GButton export_button, graph_button, heatmap_button;
  GOption autosave_toggle;
  GWindow graph_window, heatmap_window;

  /* CONSTRUCTORS */

  Home_Page(PApplet p)
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

    update_daily_durations();

    set_static_gui();
  }


  void die()
  {
    // println(controls.size());
    for (GAbstractControl c : static_controls)
    {
      if (c != null)
      {
        c.dispose();
      }
    }
  }

  /* ADDITIONAL METHODS */

  void set_static_gui()
  {
    title = new GLabel(parent, width/2 - 150, 70, 300, 40, "HOME PAGE");
    title.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
    title.setTextBold();
    title.setTextItalic();
    title.setOpaque(true);
    title.setLocalColor(6, accent_col);

    autosave_toggle = new GOption(parent, 400, 150, 200, 40, "Auto Save");
    autosave_toggle.setSelected(auto_save);
    autosave_toggle.addEventHandler(parent, "autosave_toggle_handler");

    export_button = new GButton(parent, 400, 200, 200, 40, "Export Data");
    export_button.addEventHandler(parent, "export_button_handler");

    graph_button = new GButton(parent, 400, 250, 200, 40, "View Graph");
    graph_button.addEventHandler(parent, "graph_button_handler");

    heatmap_button = new GButton(parent, 400, 300, 200, 40, "View Heatmap");
    heatmap_button.addEventHandler(parent, "heatmap_button_handler");

    insights = new GLabel(parent, 300, 300, 500, 300);

    String str = "Insights:\n";

    str += "You spend " + nf(get_average_duration(7), 0, 2) + " minutes on average cooking in the past 7 days.\n";
    str += "You spend " + nf(get_average_duration(30), 0, 2) + " minutes on average cooking in the past 30 days.\n";
    str += "You spend " + nf(get_average_duration(365), 0, 2) + " minutes on average cooking in the past year.\n";
    str += "Your longest streak is " + get_longest_streak() + " days.\n";

    insights.setText(str);

    static_controls.add(title);
    static_controls.add(autosave_toggle);
    static_controls.add(export_button);
    static_controls.add(graph_button);
    static_controls.add(insights);
  }
}

/* EVENT HANDLERS */

public void autosave_toggle_handler(GOption option, GEvent event)
{

  if (event == GEvent.SELECTED)
  {
    auto_save = true;
  }
  else if (event == GEvent.DESELECTED)
  {
    auto_save = false;
  }
}


public void export_button_handler(GButton button, GEvent event)
{
  if (event == GEvent.CLICKED)
  {
    export_data();
  }
}


public void graph_button_handler(GButton button, GEvent event)
{
  if (event == GEvent.CLICKED)
  {
    if (hp.graph_window == null)
    {
      open_graph_window();
    }
    else
    {
      println("Graph window already open");
    }
  }
}


void open_graph_window()
{
  hp.graph_window = GWindow.getWindow(this, "Graph", 200, 150, 1200, 600, JAVA2D);
  hp.graph_window.addDrawHandler(this, "graph_window_draw");
  hp.graph_window.addOnCloseHandler(this, "graph_window_close");
  hp.graph_window.setActionOnClose(G4P.CLOSE_WINDOW);
}


public void graph_window_draw(PApplet appc, GWinData data)
{
  draw_scatter_plot(appc, 14);
}


public void graph_window_close(GWindow window)
{
  hp.graph_window.dispose();
  hp.graph_window = null;
}


public void heatmap_button_handler(GButton button, GEvent event)
{
  if (event == GEvent.CLICKED)
  {
    if (hp.heatmap_window == null)
    {
      open_heatmap_window();
    }
    else
    {
      println("Heatmap window already open");
    }
  }
}


public void open_heatmap_window()
{
  hp.heatmap_window = GWindow.getWindow(this, "Heatmap", 200, 300, 1200, 200, JAVA2D);
  hp.heatmap_window.addDrawHandler(this, "heatmap_window_draw");
  hp.heatmap_window.addOnCloseHandler(this, "heatmap_window_close");
  hp.heatmap_window.setActionOnClose(G4P.CLOSE_WINDOW);
}


public void heatmap_window_draw(PApplet appc, GWinData data)
{
  drawHeatMap(appc);
}


public void heatmap_window_close(GWindow window)
{
  hp.heatmap_window.dispose();
  hp.heatmap_window = null;
}
