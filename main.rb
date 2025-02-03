$LOAD_PATH << '.'
require "jsonInitialization_module"
require "passwordGenerator_module"

def initialization user, password
    include JsonInitialization_Module
    init = JsonInitialization_Module::JsonInitialization_Class.new
    init.account_json_setup user, password
    init.passwords_json_backup password
end

def password_generator passwordLength
    include PasswordGenerator_Module
    pwdGenerator = PasswordGenerator_Module::PasswordGenerator_Class.new
end 

def update_json password

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