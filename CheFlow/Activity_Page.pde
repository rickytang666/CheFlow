
/** ACTIVITY PAGE CLASS **/

class Activity_Page extends Page
{
  /* FIELDS */

  ArrayList<GAbstractControl> static_controls = new ArrayList<GAbstractControl>();
  GLabel title;

  /* CONSTRUCTORS */

  Activity_Page(PApplet p)
  {
    super(p);
  }

  /* IMPLEMENTED METHODS */

  void setup()
  {
    title = new GLabel(parent, 300, 100, 500, 50, "This is the Activity Page");
    static_controls.add(title);
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
  }

  /* ADDITIONAL METHODS */
}
