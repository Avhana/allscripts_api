# frozen_string_literal: true

# Checks the ENV with `check_env` to see if secrets are already set
# by this file or from an external source, e.g. CI. If they exist
# a variable is set to prevent test skipping. If they are not present,
# `load_yaml_to_env` attempts to load them from an YAML file, and sets
# the flag as well.
# If both cases fail, the flag is set to true so that tests attempting to
# make api calls are skipped.
#
# NOTE: this does not protect against bad configuration or bad credentials.
def check_and_load_secrets
  load_yaml_to_env unless check_env
  @no_secrets = false
rescue
  puts %(You need to create a spec/fixtures/secrets.yml file and
        add your credentials, or load those credentials into the ENV
        to run some tests.)
  @no_secrets = true
end

# checks to see if secrets are already set
def check_env
  ENV["app_name"] &&
    ENV["app_password"] &&
    ENV["app_username"]
end

# loads secrets from YAML and sets the ENV or raises.
def load_yaml_to_env
  secrets = YAML.safe_load(File.read("spec/fixtures/secrets.yml"))
  secrets.map { |key_name, secret| ENV[key_name] = secret }
end

def build_and_auth_client
  client =
    AllscriptsApi::Client.new("http://twlatestga.unitysandbox.com/",
                              ENV["app_name"],
                              ENV["app_username"],
                              ENV["app_password"])
  client.get_token
  client.get_user_authentication("jmedici", "password01")

  client
end
