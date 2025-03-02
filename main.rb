$LOAD_PATH << '.'
require_relative "main_methods/initialize_json/initializationOfJson"
require_relative "main_methods/password_generator/passwordGenerator"
require_relative "main_methods/update_json/UpdateOfJson"

def initialization user, password
  init = Initialization_Of_Json.new 
  init.setupAccountJson user, password
  init.backupPasswordsJson password
end

def password_generator passwordLength
  generator = Password_Generator.new
  generator.setPassword passwordLength
  password = generator.password
  puts password
end 

def update_json new_password
  update = Update_Of_Json.new
  update.updateAccountJson new_password
  update.updateBackupJson new_password
end 

def main
  # Initialization
  user = "Test_TT.User"
  password = "abcdeABCDE1234"
  initialization user, password

  # Passwords Generator
  passwordLength = 20
  password_generator passwordLength

  # To update the .json of the account and passwords_backup because we save them in json file
  password = "edcbaEDCBA4321"
  update_json password
end

if __FILE__ == $0
  main
end