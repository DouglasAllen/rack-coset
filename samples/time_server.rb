require '../lib/coset'

class TimeServer < Coset

  GET "/time{EXT}" do

    now = Time.now

    wants "text/html" do

      res.write "<title>Current time</title>\n"

      res.write "It’s now #{now}.\n"

    end

    wants "text/plain" do

      res["Content-Type"] = "text/plain"

      res.write now.to_s + "\n"

    end

    wants "application/json" do

      res["Content-Type"] = "application/json"

      res.write "{\"current_time\": \"#{now}\"}\n"
    end
  end
end

app = TimeServer.new
# app = Rack::Lint.new(app)
# app = Rack::ShowExceptions.new(app)
app = Rack::ShowStatus.new(app)
app = Rack::CommonLogger.new(app)

Rack::Handler::WEBrick.run app, :Port => 3333
