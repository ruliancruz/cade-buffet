class MessagesController < ApplicationController
  before_action :validate_buffet_creation, only: [:create]

  def create
    @message = Message.new params.require(:message).permit(:text)
      .merge! order_id: params.require(:order_id)

    client_signed_in? ? @message.author = :client : @message.author = :buffet

    @message.save ? flash[:notice] = 'Mensagem enviada com sucesso!' :
      flash[:notice] = 'Digite sua mensagem antes de enviá-la.'

    redirect_to @message.order
  end
end