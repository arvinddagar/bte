User.find_or_create_by(email: "admin@bte.com") do |u|
  u.admin = true
  u.password = "password"
end

student = User.find_or_create_by(email: "student@bte.com") do |u|
  u.password = "password"
end
student.confirm!

tutor = User.find_or_create_by(email: "tutor@bte.com") do |u|
  u.password = "password"
end

tutor.confirm!

Student.find_or_create_by(username: "Jack") do |u|
  u.user = student
end

Tutor.find_or_create_by(name: "Prof. Tannenbaum") do |u|
  u.user = tutor
end

