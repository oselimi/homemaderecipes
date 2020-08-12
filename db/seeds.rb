# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

#create user

20.times do |n|
    first_name = Faker::Name.first_name
    last_name = Faker::Name.last_name
    handle_name = "user-#{n+1}"
    email = "user-#{n+1}@example.com"
    password = "password"
    
    User.create!(
        first_name: first_name,
        last_name: last_name,
        handle_name: handle_name,
        email: email,
        password: password, 
        password_confirmation: password
    )

end

users = User.all
user = users.first
## Create Recipe 
5.times do
    title = "Best-Ever Cheese Straws"
    description = "Crunchy, flaky, and cheesy. What's not to love? These cheese straws are studded with cheddar, green onions, and sesame seeds for the most flavor-packed cheese straws we've ever had. Using store-bought puff pastry makes them extremely easy to pull together for a party! 
                    Have you made these yet? Let us know how it went in the comments below! "
    recipe = Recipe.create!(
        title: title,
        description: description,
        user: user )
end
recipes = Recipe.all

## Create Ingredients
3.times do
    amount = "2 oz. finely grated sharp cheddar"
   
    recipes.each { |recipe| recipe.ingredients.create!(amount: amount, user: user) }
end

## Create instructions
3.times do
    step = "Step"
    body = "Preheat oven to 425°. Mix cheddar, flour, scallions, and sesame seeds in a small bowl."

    recipes.each { |recipe| recipe.instructions.create!(step: step, body: body, user: user) }
end


