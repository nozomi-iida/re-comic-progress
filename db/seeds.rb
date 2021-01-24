User.create(name: "AdminUser",
            email: "admin@test.com",
            password: "password",
            password_confirmation: "password",
            admin: true,
            activated: true,
            activated_at: Time.zone.now
           )

20.times do |n|
  name = "test#{n}"
  email = "test#{n}@test.com"
  password = "password"
  User.create!(name: name,
               email: email,
               password: password,
               password_confirmation: password,
               admin: false,
               activated: true,
               activated_at: Time.zone.now
              )
end

users = User.order(:created_at).take(6)

30.times do |n|
  title = "test #{n}comics"
  volume = n
  users.each{ |user| user.comics.create!(title: title, volume: volume) }

end
