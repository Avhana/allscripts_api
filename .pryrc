require "allscripts_api"

begin
  loaded = ENV["app_name"] && ENV["app_password"] && ENV["unity_url"] && ENV["app_username"]
  unless loaded
    secrets = YAML.safe_load(File.read("spec/fixtures/secrets.yml"))
    secrets.map { |key_name, secret| ENV[key_name] = secret }
  end
rescue => exception
  puts(exception)
end
