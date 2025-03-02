$LOAD_PATH << '.'
require "json_classes/settings/jsonSettings_module.rb"
require "json_classes/controller/jsonController_module.rb"

class Initialization_Of_Json
  include JsonSettings
  include JsonController

  public

  def setupAccountJson user, password
    data = {
      "account"=> {
        "user"=> user, 
        "password"=> password
      },
      "domain_name"=> {
        "at"=> "@",
        "email"=> "example.com"
      }
    }
    # json writer
    JsonController.jsonWriter JsonSettings::ACCOUNT_PATH, data
    # json viewer
    data = JsonController.jsonReader JsonSettings::ACCOUNT_PATH
    JsonController.jsonViewer data
  end 

  def backupPasswordsJson password
    data = {
      "length": 1, 
      "account_passwords": [
        {
          "number": 0, 
          "password": password
        }
      ]
    }
    # json writer
    JsonController.jsonWriter JsonSettings::PASSWORDS_BACKUP_PATH, data
    # json viewer
    data = JsonController.jsonReader JsonSettings::PASSWORDS_BACKUP_PATH
    JsonController.jsonViewer data
  end
end

def main user, password
  init = Initialization_Of_Json.new 
  init.setupAccountJson user, password
  init.backupPasswordsJson password
end

if __FILE__ == $0
  user = "Test_TT.User"
  password = "abcdeABCDE1234"
  main user, password
end