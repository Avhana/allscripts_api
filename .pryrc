require "allscripts_api"
require "yaml"
require "awesome_print"
require "base64"
AwesomePrint.pry!
AwesomePrint.defaults = { raw: true }

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
    AllscriptsApi::Client.new("http://twlatestga.unitysandbox.com/",
                              ENV["app_name"],
                              ENV["app_username"],
                              ENV["app_password"])
  client.get_token
  client.get_user_authentication("jmedici", "password01")

  client
end

def document_params(pdf)
  {
    bytes_read: pdf.bytes.length,
    b_done_upload: false,
    document_var: "",
    patient_id: 19,
    owner_code: "TW0001",
    first_name: "Allison",
    last_name: "Allscripts",
    document_type: "gwn_otfm",   #document_type_de.entrycode value GetDictionary
    organization_name: "New World Health"
  }
end

def pdf
  File.open("spec/fixtures/hba1c_sample.pdf").read
end

def encoded_pdf
  Base64.encode64(pdf)
end
