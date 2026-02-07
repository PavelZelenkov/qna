# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

ActiveRecord::Base.transaction do
  puts "Seeding..."

  # 1) Users (Devise)
  admin = User.find_or_initialize_by(email: "admin@example.com")
  if admin.new_record?
    admin.password = "qwerty"
    admin.password_confirmation = "qwerty"
  end
  admin.confirmed = true if admin.respond_to?(:confirmed=) # поле есть в схеме
  admin.admin = true if admin.respond_to?(:admin=)
  admin.save!

  users = %w[user1@example.com user2@example.com user3@example.com].map do |email|
    u = User.find_or_initialize_by(email: email)
    if u.new_record?
      u.password = "qwerty"
      u.password_confirmation = "qwerty"
    end
    u.confirmed = true if u.respond_to?(:confirmed=)
    u.save!
    u
  end

  # 2) Questions
  questions_data = [
    { title: "Question 1", body: "Test body question 1", author: admin },
    { title: "Question 2", body: "Test body question 2", author: users[0] },
    { title: "Question 3", body: "Test body question 3", author: users[1] },
    { title: "Question 4", body: "Test body question 4", author: users[2] },
    { title: "Question 5", body: "Test body question 5", author: admin }
  ]

  questions = questions_data.map do |q|
    Question.find_or_create_by!(title: q[:title], author: q[:author]) do |qq|
      qq.body = q[:body]
    end
  end

  # 3) Answers (and comments/votes)
  questions.each_with_index do |q, idx|
    a1 = Answer.find_or_create_by!(question: q, author: users[idx % users.size], body: "Body answer ##{idx + 1}")
    a2 = Answer.find_or_create_by!(question: q, author: admin, body: "Admin body answer")

    Comment.find_or_create_by!(user: admin, commentable: q) { |c| c.body = "Comment answer 1" }
    Comment.find_or_create_by!(user: users.first, commentable: a1) { |c| c.body = "Comment answer 2" }

    # Vote
    v = Vote.find_or_initialize_by(user: admin, votable: q)
    v.value = 1
    v.save!

    v2 = Vote.find_or_initialize_by(user: users.first, votable: a1)
    v2.value = 1
    v2.save!
  end

  # 4) Subscriptions
  questions.first(2).each do |q|
    Subscription.find_or_create_by!(user: users.first, question: q)
  end

  puts "Seed done."
end
