# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
a1 = Admin.where(email: "clairezuliani+admin@gmail.com").first_or_initialize
if ["production","staging"].include?(Rails.env)
  a1.update_attributes(:password => "aqwxsz21")
else
  a1.update_attributes(:password => "password")
end

seo1 = Seo.where(param: "home").first_or_create