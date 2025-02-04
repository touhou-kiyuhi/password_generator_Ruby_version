$LOAD_PATH << '.'
require "jsonPath_abstractModule"
require "jsonController_module"

class JsonInitialization
  include JsonPath
  include JsonController

  public

  def account_json_setup user, password
    data = {
      "welltake_account"=> {
        "user"=> user, 
        "password"=> password
      },
      "welltake_domain_name"=> {
        "at"=> "@",
        "email"=> "welltake.com.tw"
      }
    }
    JsonController.jsonWriter JsonPath::ACCOUNT_PATH, data
  end 

  def passwords_json_backup password
    data = {
      "length": 1, 
      "welltake_account_passwords": [
        {
          "number": 0, 
          "password": password
        }
      ]
    }
    JsonController.jsonWriter JsonPath::PASSWORDS_BACKUP_PATH, data
  end
end

if __FILE__ == $0
  init = JsonInitialization.new 
  user = "Test_TT.User"
  password = "abcdeABCDE1234"
  init.account_json_setup user, password
  init.passwords_json_backup password
end