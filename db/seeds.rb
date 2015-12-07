# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.create!(role: Role::ADMIN, login: 'admin', password: 'admin')
User.create!(role: Role::USER, login: 'user', password: 'user')
User.create!(role: Role::GUEST, login: 'guest', password: 'guest')

5.times do |i|
  epic = Epic.create!(title: "A title #{i}", description: "A description #{i}", priority: rand(3))
  5.times do |j|
    Story.create!(body: "A story #{j} for epic #{epic.title}", status: rand(3), epic_id: epic.id)
  end
end
