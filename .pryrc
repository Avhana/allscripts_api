require "allscripts_api"
require "yaml"

begin
  loaded = ENV["app_name"] && ENV["app_password"] && ENV["unity_url"] && ENV["app_username"]
  unless loaded
    secrets = YAML.safe_load(File.read("spec/fixtures/secrets.yml"))
    secrets.map { |key_name, secret| ENV[key_name] = secret }
  end
rescue => exception
  puts(exception)
end

def bc
  client =
    AllscriptsApi::Client.new(ENV["unity_url"],
                              ENV["app_name"],
                              ENV["app_username"],
                              ENV["app_password"])
  client.get_token
  client.get_user_authentication("jmedici", "password01")

  client
end