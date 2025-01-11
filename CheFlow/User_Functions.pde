
/* GLOBAL VARIABLES OR CONSTANTS */

GButton export_button;
HashMap<String, Ingredient> ingredient_map = new HashMap<String, Ingredient>();

/* FUNCTIONS */

void export_recipes()
{
  JSONArray recipes_array = new JSONArray();

  for (Recipe r : recipes)
  {
    JSONObject recipe_obj = new JSONObject();
    recipe_obj.setInt("id", r.id);
    recipe_obj.setString("name", r.name);

    JSONArray ingredients_array = new JSONArray();
    for (Ingredient ing : r.ingredients)
    {
      JSONObject ingredient_obj = new JSONObject();
      ingredient_obj.setString("name", ing.name);
      ingredients_array.append(ingredient_obj);
    }

    recipe_obj.setJSONArray("ingredients", ingredients_array);
    recipes_array.append(recipe_obj);
  }


  try
  {
    saveJSONArray(recipes_array, "recipes.json");
    println("Recipes saved successfully");
  }
  catch (Exception e)
  {
    println("Error saving recipes");
  }
}


void import_recipes()
{
  JSONArray recipes_array = loadJSONArray("recipes.json");

  if (recipes_array == null)
  {
    println("Error loading recipes");
    return;
  }

  recipes.clear();
  library_ingredients.clear();
  ingredient_id = 1;
  recipe_id = 1;

  for (int i = 0; i < recipes_array.size(); i++)
  {
    JSONObject recipe_obj = recipes_array.getJSONObject(i);
    Recipe r = new Recipe(recipe_obj.getString("name"));

    JSONArray ingredients_array = recipe_obj.getJSONArray("ingredients");
    for (int j = 0; j < ingredients_array.size(); j++)
    {
      JSONObject ingredient_obj = ingredients_array.getJSONObject(j);
      Ingredient ing = new Ingredient(ingredient_obj.getString("name"));

      
      r.add_ingredient(ing);
      
    }

    recipes.add(r);
  }

  sort_recipes(1);
  totalPages[0] = (int) ceil((float) recipes.size() / buttonsPerPage);
  set_recipes_page();
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

/* EVENT HANDLERS */

public void export_button_handler(GButton button, GEvent event)
{
  if (event == GEvent.CLICKED)
  {
    export_recipes();
  }
}
