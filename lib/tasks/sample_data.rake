require 'faker'

namespace :db do
  desc "Fill databese with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    admin = User.create!(:name => "avee",
                 :email => "kokepiking@gmail.com",
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
    User.all(:limit => 6).each do |user|
      50.times do 
        user.microposts.create!(:content => Faker::Lorem.sentence(5))
      end
    end
  end
end
