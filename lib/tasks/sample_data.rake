require 'faker'

namespace :db do
  desc "Fill databese with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    admin = User.create!(:name => "Example User",
                 :email => "test@exmaple.com",
                 :password => "pass",
                 :password_confirmation => "pass")
    admin.toggle!(:admin)
    99.times do |n|
      name = Faker::Name.name
      email = "test#{n+1}@example.com"
      password = "password"
      User.create!(:name => name,
                   :email => email,
                   :password => password,
                   :password_confirmation => password)
    end
  end
end
