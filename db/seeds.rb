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

dan = User.create(
  first_name: "Daniel", 
  last_name: "Goldberg", 
  birthday: "18-06-1993".to_date, 
  email: "danpaulgo@aol.com", 
  password: "BayShore61893",
  activated: true,
  activated_at: Time.zone.now)
  dan.assets.create(
    type_id: 1, 
    name: "Personal Wallet", 
    amount: 100.0, 
    liquid: true, 
    primary: true)
  dan.assets.create(
    type_id: 2, 
    name: "Checking Account", 
    amount: 0.0, 
    liquid: true, 
    primary: true)
john = User.create(
  first_name: "John", 
  last_name: "Doe", 
  birthday: "01-01-2000".to_date, 
  email: "johndoe2000@gmail.com", 
  password: "password",
  activated: true,
  activated_at: Time.zone.now)
  john.assets.create(type_id: 2, name: "Checking Account", amount: 1000.0, liquid: true, primary: true, interest: 1.1, compound_frequency: "Yearly")
  
  25.times do
    asset_name = (0...10).map { ('a'..'z').to_a[rand(26)] }.join
    asset_amount = rand(10000)/1.0
    asset_primary = false
    asset_type = (1..13).to_a.sample
    case asset_type
    when 1,2
      asset_liquid = true
      asset_primary = true
    when 3,4
      asset_liquid = true
    when 8,9,10,11,12
      asset_liquid = false
    else
      asset_liquid = [true,false].sample
    end 
    john.assets.create(
      type_id: asset_type, 
      name: asset_name,
      liquid: asset_liquid, 
      amount: asset_amount, 
      primary: asset_primary,
    )

    debt_type = rand(5)+14
    debt_name = (0...8).map { ('a'..'z').to_a[rand(26)] }.join
    debt_amount = rand(10000)/1.0
    debt_interest = rand(100)/10.0
    john.debts.create(
      type_id: debt_type, 
      name: debt_name, 
      amount: debt_amount, 
      interest: debt_interest, 
      compound_frequency: "Yearly"
    )

    income_name = (0...8).map { ('a'..'z').to_a[rand(26)] }.join
    income_amount = rand(500)/1.0
    income_type = (19..24).to_a.sample
    income_next_date = Date.today
    income_end_date =  [Date.new(2020),Date.new(2030)].sample
    income_frequency = ["One-Time", "Monthly", "Weekly", "Yearly"].sample
    john.incomes.create(
      type_id: income_type,
      name: income_name,
      amount: income_amount,
      associated_asset_id: 3,
      frequency: income_frequency,
      next_date: income_next_date,
      end_date: income_end_date
    )

    expense_name = (0...8).map { ('a'..'z').to_a[rand(26)] }.join
    expense_amount = rand(500)/1.0
    expense_type = (25..35).to_a.sample
    expense_next_date = Date.tomorrow
    expense_end_date =  [Date.new(2020),Date.new(2030), nil].sample
    expense_frequency = ["One-Time", "Monthly", "Weekly", "Yearly"].sample
    john.expenses.create(
      type_id: expense_type,
      name: expense_name,
      amount: expense_amount,
      associated_asset_id: 3,
      frequency: expense_frequency,
      next_date: expense_next_date,
      end_date: expense_end_date
    )
  end

  25.times do

    primary_assets = john.assets.all.map{|a| a.id if a.primary == true}.compact
    liquid_assets = john.assets.all.map{|a| a.id if a.liquid == true}.compact
    all_assets = john.assets.all.map{|a| a.id}
    all_debts = john.debts.all.map{|d| d.id}

    transfer_amount = rand(1000)/1.0
    transfer_type = [37,38].sample
    transfer_next_date = Date.tomorrow
    transfer_end_date =  [Date.new(2020),Date.new(2030), nil].sample
    transfer_frequency = ["One-Time", "Monthly", "Weekly", "Yearly"].sample
    transfer_liquid_asset_id = liquid_assets.sample
    if transfer_type == 37
      transfer_origin_id = liquid_assets.sample
      liquid_assets.delete(transfer_origin_id)
      transfer_destination_id = liquid_assets.sample
      destination_name = Asset.find(transfer_destination_id)
    elsif transfer_type == 38
      transfer_origin_id = primary_assets.sample
      transfer_destination_id = all_debts.sample
      destination_name = Debt.find(transfer_destination_id).name
    end
    transfer = john.transfers.create(
      type_id: transfer_type,
      name: "#{Asset.find(transfer_origin_id).name} -> #{destination_name}",
      amount: transfer_amount,
      next_date: transfer_next_date,
      end_date: transfer_end_date,
      frequency: transfer_frequency,
      liquid_asset_from_id: transfer_origin_id,
      destination_id: transfer_destination_id
    )

  end

ResourceName.create(name: "Asset", table_name: "assets")
# ResourceName.create(name: "Assets (non-liquid)", table_name: "asset_non_liquids")
ResourceName.create(name: "Debt", table_name: "debts")
ResourceName.create(name: "Income", table_name: "incomes")
ResourceName.create(name: "Expense", table_name: "expenses")
ResourceName.create(name: "Transfer", table_name: "transfers")

ResourceType.create(name: "Cash on Hand", resource_name_id: 1)
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
ResourceType.create(name: "Vehicle Loan", resource_name_id: 2)
ResourceType.create(name: "Personal Loan", resource_name_id: 2)
ResourceType.create(name: "Personal Debt", resource_name_id: 2)
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
ResourceType.create(name: "Asset to Asset", resource_name_id: 5)
ResourceType.create(name: "Debt Payment", resource_name_id: 5)





