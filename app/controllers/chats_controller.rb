class ChatsController < ApplicationController
  
  before_action :reject_non_related, only: [:show]
  #reject_non_relatedメソッドがbefore_actionとして指定されているため、showアクションが実行される前に実行されます。
  
  def show
    @user = User.find(params[:id])
    rooms = current_user.user_rooms.pluck(:room_id)#カレントユーザーが関連するルーム（チャットルーム）のIDを取得します。
    user_rooms = UserRoom.find_by(user_id: @user.id, room_id: rooms)

    unless user_rooms.nil?#指定されたユーザーと関連するルームが存在するかどうかをチェック
      @room = user_rooms.room#存在する場合
    else
      @room = Room.new
      @room.save
      UserRoom.create(user_id: current_user.id, room_id: @room.id)#カレントユーザーと指定されたユーザーの間にユーザールームを作成
      UserRoom.create(user_id: @user.id, room_id: @room.id)
    end
    @chats = @room.chats#@roomに関連するチャットを取得します。
    @chat = Chat.new(room_id: @room.id)#@chat変数に新しいチャット（メッセージ）のインスタンスを作成します。このとき、@roomのIDも指定します。
  end
  
  def create
    @chat = current_user.chats.new(chat_params)
    render :validater unless @chat.save#現在のユーザーに関連するチャットを作成し、保存します。 - もし保存に失敗した場合は、エラーメッセージを表示します。
  end

  private
  def chat_params
    params.require(:chat).permit(:message, :room_id)
  end

  def reject_non_related
    user = User.find(params[:id])
    unless current_user.following?(user) && user.following?(current_user)
      redirect_to books_path
    end#reject_non_relatedメソッドでは、表示するユーザーと現在のユーザーが互いにフォロー関係にない場合に、ブックのページにリダイレクトします。
  end
  
end
