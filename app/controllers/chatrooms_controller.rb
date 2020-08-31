class ChatroomsController < ApplicationController
  def index
    @user = current_user
    @chatrooms_receiver = Chatroom.where(receiver_id: @user.id)
    @chatrooms_sender = Chatroom.where(sender_id: @user.id)
    count = 0
    Chatroom.all.each do |chatroom|
      count += chatroom.messages.select { |message| message.receiver_viewed != true && message.user_id != current_user.id }.count
    end
    @unread_messages = count
  end

  def show
    @chatroom = Chatroom.find(params[:id])
    @message = Message.new
  end

  def new
    @chatroom = Chatroom.new
  end

  def open
    @sender = current_user
    @receiver = User.find(params[:user_id])
    @message = Message.new
    @chatroom = Chatroom.where(sender_id: @sender.id, receiver_id: @receiver.id)
                        .or(Chatroom.where(sender_id: @receiver.id, receiver_id: @sender.id)).first
    if @chatroom.nil?
      @chatroom = Chatroom.create(sender_id: @sender.id, receiver_id: @receiver.id, receiver_name: @receiver.first_name, sender_name: @sender.first_name)
    end

    unread_messages = @chatroom.messages.select { |message| message.receiver_viewed != true && message.user_id != current_user.id }
    unread_messages.each do |message|
      message.receiver_viewed = true
      message.save
    end

    render 'show'
  end
end
