class DashboardController < ApplicationController
  def index
    @redemptions = Redemption.all.order(claimed_at: :desc)
  end

  def announce
    message = params[:announcement]
    
    if $minecraft_ws && message.present?
      raw_msg = {
        rawtext: [
          { text: "[§l§bANNOUNCEMENT§r] §l§e»§r §e#{message}§r" }
        ]
      }.to_json

      commands = [
        "tellraw @a #{raw_msg}",
        "playsound note.pling @a ~~~ 10.0 0.9",
        "title @a title §e#{message}"
      ]

      commands.each do |cmd|
        $minecraft_ws.send({
          header: { version: 1, requestId: SecureRandom.uuid, messageType: "commandRequest", messagePurpose: "commandRequest" },
          body: { commandLine: cmd, version: 1 }
        }.to_json(ascii_only: true))
      end
      flash[:notice] = "Broadcast deployed."
    else
      flash[:alert] = "Connection lost."
    end
    redirect_to root_path
  end

  def destroy
    @redemption = Redemption.find(params[:id])
    @redemption.destroy
    
    flash[:notice] = "Player data removed from database."
    redirect_to root_path
  end
end