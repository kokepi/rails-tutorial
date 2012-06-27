Factory.define :user do |user|
  user.name "Tatsuki ABE"
  user.email "tatsuki.abe@gmail.com"
  user.password "ntm3"
  user.password_confirmation "ntm3"
end

Factory.sequence :email do |n|
  "person#{n}@example.com"
end

Factory.define :micropost do |micropost|
  micropost.content "Foo Bar"
  micropost.association :user
end
