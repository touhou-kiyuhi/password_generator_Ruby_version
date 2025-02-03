$LOAD_PATH << '.'
require "jsonPath_AbstractModule"
require "jsonController_module"

module JsonInitialization_Module
  class JsonInitialization_Class

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
end