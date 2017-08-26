# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

state_rate_pairs = [["MA", 6.17], ["NY", 5.42], ["NH", 4.88], ["ME", 5.06], ["VT", 4.75], ["RI", 5.44], ["CT", 4.94], ["NJ", 5.46], ["DC", 7.26], ["DE", 4.13], ["MD", 5.05], ["PA", 4.37], ["WV", 3.29], ["VA", 4.76], ["NC", 4.11], ["SC", 4.05], ["GA", 3.72], ["FL", 4.49], ["OH", 3.58], ["KY", 3.96], ["TN", 4.02], ["AL", 3.59], ["MS", 3.23], ["IN", 3.68], ["MI", 4.0], ["WI", 4.12], ["IL", 4.16], ["MN", 4.66], ["IA", 3.76], ["MO", 3.82], ["AR", 3.62], ["LA", 4.21], ["ND", 4.38], ["SD", 4.17], ["NE", 3.84], ["KS", 3.61], ["OK", 3.81], ["TX", 4.15], ["MT", 5.09], ["WY", 4.68], ["CO", 5.63], ["NM", 4.28], ["ID", 4.28], ["UT", 5.02], ["AZ", 4.72], ["NV", 4.78], ["WA", 6.25], ["OR", 5.84], ["CA", 6.8], ["AK", 4.27], ["HI", 6.31]]
state_rate_pairs.each do |pair|
  RealEstateAppreciation.create(state: pair[0], appreciation: pair[1])
end

dan = User.create(name: "Daniel Goldberg", username: "danpaulgo", password: "BayShore61893")
  dan.assets.create(name: "Cash", amount: 0.0, primary: true, liquid: true)
  dan.assets.create(name: "Checking Account", amount: 0.0, primary: true, liquid: true)
john = User.create(name: "John Doe", username: "johndoe2000", password: "password")
  john.assets.create(name: "Cash", amount: 0.0, primary: true, liquid: true)
  john.assets.create(name: "Checking Account", amount: 0.0, primary: true, liquid: true)