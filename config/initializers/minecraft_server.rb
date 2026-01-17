require 'em-websocket'
require 'json'
require 'securerandom'

$minecraft_ws = nil

if defined?(Rails::Server)
  Thread.new do
    sleep 3
    EM.run do
      puts "\n" + "="*40
      puts "Wsserver running on port:8000"
      puts "="*40

      EM::WebSocket.run(host: "0.0.0.0", port: 8000) do |ws|
        ws.onopen do
          $minecraft_ws = ws
          puts "[MC] Connected"
          
          ws.send({
            header: { version: 1, requestId: SecureRandom.uuid, messageType: "commandRequest", messagePurpose: "commandRequest" },
            body: { commandLine: "playsound random.levelup @a", version: 1 }
          }.to_json)

          ws.send({
            header: { version: 1, requestId: SecureRandom.uuid, messageType: "commandRequest", messagePurpose: "subscribe" },
            body: { eventName: "PlayerMessage" }
          }.to_json)
        end

        ws.onmessage do |msg|
          ActiveRecord::Base.connection_pool.with_connection do
            begin
              data = JSON.parse(msg)
              if data.dig("header", "eventName") == "PlayerMessage"
                sender = data.dig("body", "sender")
                message = data.dig("body", "message")

                if message == "SUMMER2016" && sender != "External"
                  if Redemption.exists?(player_name: sender, code: "SUMMER2016")
                    ws.send({
                      header: { version: 1, requestId: SecureRandom.uuid, messageType: "commandRequest", messagePurpose: "commandRequest" },
                      body: { commandLine: "tellraw \"#{sender}\" {\"rawtext\":[{\"text\":\"§cYou already claimed this!\"}]}", version: 1 }
                    }.to_json(ascii_only: true))
                  else
                    Redemption.create!(player_name: sender, code: "SUMMER2016", claimed_at: Time.current)

                    raw_redeem_msg = {
                      rawtext: [{ text: "[§l§bSERVER§r] §aCode redeemed by §e#{sender}" }]
                    }.to_json
                    
                    send_cmd = ->(cmd) {
                      ws.send({
                        header: { version: 1, requestId: SecureRandom.uuid, messageType: "commandRequest", messagePurpose: "commandRequest" },
                        body: { commandLine: cmd, version: 1 }
                      }.to_json(ascii_only: true))
                    }
                    send_cmd.call("tellraw @a #{raw_redeem_msg}")
                    send_cmd.call("title \"#{sender}\" actionbar §a+3000 XP")
                    send_cmd.call("xp 3000 \"#{sender}\"")
                    send_cmd.call("playsound random.orb @a")
                  end
                end
              end
            rescue; next; end
          end
        end

        ws.onclose { $minecraft_ws = nil; puts "[MC] Close Connection" }
      end
    end
  rescue => e
    puts "[WS-FATAL] #{e.message}"
  end
end