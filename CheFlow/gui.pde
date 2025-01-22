// Common GUIs

GImageButton prev_button, next_button;

public void createGUI()
{
  G4P.messagesEnabled(false);

  float navButtonY = height - 50;
    
  prev_button = new GImageButton(this, width / 2 - 60, navButtonY,  button_height, button_height, new String[] {"previous 1.png", "previous 2.png"});
  prev_button.addEventHandler(this, "page_button_handler");

  next_button = new GImageButton(this, width / 2 + 60, navButtonY, button_height, button_height, new String[] {"next 1.png", "next 2.png"});
  next_button.addEventHandler(this, "page_button_handler");
}


public void page_button_handler(GImageButton button, GEvent event)
{
  if (event == GEvent.CLICKED)
  {
    if (button == prev_button)
    {
      page_nums[layer]--;
    }
    else if (button == next_button)
    {
      page_nums[layer]++;
    }

    if (current_Page == rp)
    {
      rp.set_recipes_page();
    }
    else if (current_Page == fp)
    {
      fp.set_fridge_page();
    }
    else if (current_Page == mp)
    {
      mp.set_matching_page();
    }
    else if (current_Page == ap)
    {
      ap.set_activity_page();
    }

  }
}


public void back_button_handler(GImageButton button, GEvent event)
{
  if (event == GEvent.CLICKED)
  {
    page_nums[layer] = 0;
    total_page_nums[layer] = 0;
    layer--;

    if (button == rp.back)
    {
      rp.set_recipes_page();
    }
    else if (button == fp.back)
    {
      fp.set_fridge_page();
    }
    else if (button == ap.back)
    {
      ap.set_activity_page();
    }

  }
}
