class NotificationChannel < ApplicationCable::Channel
  def subscribed
    stream_from "notifications_#{params[:user_id]}"
  end

  def unsubscribed
    # Limpar qualquer configuração quando o cliente se desconectar
  end
end
