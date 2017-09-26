# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

state_rate_pairs = [["MA", 6.17], ["NY", 4.42], ["NH", 4.88], ["ME", 4.06], ["VT", 4.75], ["RI", 4.44], ["CT", 4.94], ["NJ", 4.46], ["DC", 7.26], ["DE", 4.13], ["MD", 4.05], ["PA", 4.37], ["WV", 2.29], ["VA", 4.76], ["NC", 4.11], ["SC", 4.05], ["GA", 2.72], ["FL", 4.49], ["OH", 2.58], ["KY", 2.96], ["TN", 4.02], ["AL", 2.59], ["MS", 2.23], ["IN", 2.68], ["MI", 4.0], ["WI", 4.12], ["IL", 4.16], ["MN", 4.66], ["IA", 2.76], ["MO", 2.82], ["AR", 2.62], ["LA", 4.21], ["ND", 4.38], ["SD", 4.17], ["NE", 2.84], ["KS", 2.61], ["OK", 2.81], ["TX", 4.15], ["MT", 4.09], ["WY", 4.68], ["CO", 4.63], ["NM", 4.28], ["ID", 4.28], ["UT", 4.02], ["AZ", 4.72], ["NV", 4.78], ["WA", 6.25], ["OR", 4.84], ["CA", 6.8], ["AK", 4.27], ["HI", 6.31]]
state_rate_pairs.each do |pair|
  RealEstateAppreciation.create(state: pair[0], appreciation: pair[1])
end

dan = User.create(name: "Daniel Goldberg", username: "danpaulgo", password: "BayShore61893")
  dan.assets.create(type_id: 1, name: "Cash", amount: 100.0, liquid: true, primary: true)
  dan.assets.create(type_id: 2, name: "Checking Account", amount: 0.0, liquid: true, primary: true)
john = User.create(name: "John Doe", username: "johndoe2000", password: "password")
  john.assets.create(type_id: 1, name: "Cash", amount: 0.0, liquid: true, primary: true)
  john.assets.create(type_id: 2, name: "Checking Account", amount: 0.0, liquid: true, primary: true)

ResourceName.create(name: "Asset", table_name: "assets")
# ResourceName.create(name: "Assets (non-liquid)", table_name: "asset_non_liquids")
ResourceName.create(name: "Debt", table_name: "debts")
ResourceName.create(name: "Income", table_name: "incomes")
ResourceName.create(name: "Expense", table_name: "expenses")

ResourceType.create(name: "Cash", resource_name_id: 1)
ResourceType.create(name: "Bank Account", resource_name_id: 1)
ResourceType.create(name: "Stock", resource_name_id: 1)
ResourceType.create(name: "Fund", resource_name_id: 1)
ResourceType.create(name: "Bond", resource_name_id: 1)
ResourceType.create(name: "Certificate of Deposit", resource_name_id: 1)
ResourceType.create(name: "Commodity", resource_name_id: 1)

ResourceType.create(name: "Real Estate", resource_name_id: 1)
ResourceType.create(name: "Vehicle", resource_name_id: 1)
ResourceType.create(name: "Artwork", resource_name_id: 1)
ResourceType.create(name: "Jewelry", resource_name_id: 1)
ResourceType.create(name: "Collectible", resource_name_id: 1)
ResourceType.create(name: "Other", resource_name_id: 1)

ResourceType.create(name: "Credit Card", resource_name_id: 2)
ResourceType.create(name: "Mortgage", resource_name_id: 2)
ResourceType.create(name: "Car", resource_name_id: 2)
ResourceType.create(name: "Personal", resource_name_id: 2)
ResourceType.create(name: "Other", resource_name_id: 2)

ResourceType.create(name: "Career Salary", resource_name_id: 3)
ResourceType.create(name: "Business Income", resource_name_id: 3)
ResourceType.create(name: "Income Property", resource_name_id: 3)
ResourceType.create(name: "Government Income", resource_name_id: 3)
ResourceType.create(name: "Insurance Income", resource_name_id: 3)
ResourceType.create(name: "Other", resource_name_id: 3)

ResourceType.create(name: "Rent", resource_name_id: 4)
ResourceType.create(name: "Food", resource_name_id: 4)
ResourceType.create(name: "Car Gasoline", resource_name_id: 4)
ResourceType.create(name: "Home Maintenance", resource_name_id: 4)
ResourceType.create(name: "Car Maintenance", resource_name_id: 4)
ResourceType.create(name: "Electricity Bill", resource_name_id: 4)
ResourceType.create(name: "Water Bill", resource_name_id: 4)
ResourceType.create(name: "Gas Bill", resource_name_id: 4)
ResourceType.create(name: "Phone Bill", resource_name_id: 4)
ResourceType.create(name: "Internet Bill", resource_name_id: 4)
ResourceType.create(name: "Cable Bill", resource_name_id: 4)
ResourceType.create(name: "Home Owner's Insurance", resource_name_id: 4)
ResourceType.create(name: "Car Insurance", resource_name_id: 4)
ResourceType.create(name: "Health Insurance", resource_name_id: 4)
ResourceType.create(name: "Life Insurance", resource_name_id: 4)
ResourceType.create(name: "Recreation", resource_name_id: 4)
ResourceType.create(name: "Transportation", resource_name_id: 4)
ResourceType.create(name: "Other", resource_name_id: 4)





