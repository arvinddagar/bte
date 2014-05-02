student = User.find_or_create_by(email: "student@bte.com") do |u|
  u.password = "password"
end
student.skip_confirmation!

tutor = User.find_or_create_by(email: "tutor@bte.com") do |u|
  u.password = "password"
end

tutor.skip_confirmation!

Student.find_or_create_by(username: "Jack") do |u|
  u.user = student
end

Tutor.find_or_create_by(name: "Prof. Tannenbaum") do |u|
  u.user = tutor
end

