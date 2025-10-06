class QuestionsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "questions"
    puts "User subscribed to questions channel"
  end

  def unsubscribed
    puts "User unsubscribed from questions channel"
    # Any cleanup needed when channel is unsubscribed
  end
end
