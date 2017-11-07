# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

state_rate_data = [["Massachusetts", "MA", 6.17], ["New York", "NY", 4.42], ["New Hampshire", "NH", 4.88], ["Maine", "ME", 4.06], ["Vermont", "VT", 4.75], ["Rhode Island", "RI", 4.44], ["Connecticut", "CT", 4.94], ["New Jersey", "NJ", 4.46], ["Washington D.C.", "DC", 7.26], ["Delaware", "DE", 4.13], ["Maryland", "MD", 4.05], ["Pennsylvania", "PA", 4.37], ["West Virginia", "WV", 2.29], ["Virginia", "VA", 4.76], ["North Carolina", "NC", 4.11], ["South Carolina", "SC", 4.05], ["Georgia", "GA", 2.72], ["Florida", "FL", 4.49], ["Ohio", "OH", 2.58], ["Kentucky", "KY", 2.96], ["Tennessee", "TN", 4.02], ["Alabama", "AL", 2.59], ["Mississippi", "MS", 2.23], ["Indiana", "IN", 2.68], ["Michigan", "MI", 4.0], ["Wisonsin", "WI", 4.12], ["Illinois", "IL", 4.16], ["Minnesota", "MN", 4.66], ["Iowa", "IA", 2.76], ["Missouri", "MO", 2.82], ["Arkansas", "AR", 2.62], ["Louisiana", "LA", 4.21], ["North Dakota", "ND", 4.38], ["South Dakota", "SD", 4.17], ["Nebraska", "NE", 2.84], ["Kansas", "KS", 2.61], ["Oklahoma", "OK", 2.81], ["Texas", "TX", 4.15], ["Montana", "MT", 4.09], ["Wyoming", "WY", 4.68], ["Colorado", "CO", 4.63], ["New Mexico", "NM", 4.28], ["Idaho", "ID", 4.28], ["Utah", "UT", 4.02], ["Arizona", "AZ", 4.72], ["Nevada", "NV", 4.78], ["Washington", "WA", 6.25], ["Oregon", "OR", 4.84], ["California", "CA", 6.8], ["Alaska", "AK", 4.27], ["Hawaii", "HI", 6.31]]
state_rate_data.each do |arr|
  RealEstateAppreciation.create(name: arr[0], abbreviation: arr[1], appreciation: arr[2])
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

ResourceType.create(name: "Property", resource_name_id: 1)
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
ResourceType.create(name: "Gasoline", resource_name_id: 4)
ResourceType.create(name: "Maintenance", resource_name_id: 4)
ResourceType.create(name: "Utility", resource_name_id: 4)
# ResourceType.create(name: "Electricity Bill", resource_name_id: 4)
# ResourceType.create(name: "Water Bill", resource_name_id: 4)
# ResourceType.create(name: "Gas Bill", resource_name_id: 4)
# ResourceType.create(name: "Phone Bill", resource_name_id: 4)
ResourceType.create(name: "Media Bill", resource_name_id: 4)
# ResourceType.create(name: "Home Owner's Insurance", resource_name_id: 4)
# ResourceType.create(name: "Car Insurance", resource_name_id: 4)
ResourceType.create(name: "Insurance", resource_name_id: 4)
# ResourceType.create(name: "Life Insurance", resource_name_id: 4)
ResourceType.create(name: "Recreation", resource_name_id: 4)
ResourceType.create(name: "Transportation", resource_name_id: 4)
ResourceType.create(name: "Tax", resource_name_id: 4)
ResourceType.create(name: "Other", resource_name_id: 4)





