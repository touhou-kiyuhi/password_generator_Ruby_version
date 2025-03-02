$LOAD_PATH << '.'
require "json_classes/settings/jsonSettings_module.rb"
require "json_classes/controller/jsonController_module.rb"

class Update_Of_Json
  include JsonSettings
  include JsonController

  def initialize
    @accountData = JsonController.jsonReader JsonSettings::ACCOUNT_PATH
    @backupData = JsonController.jsonReader JsonSettings::PASSWORDS_BACKUP_PATH
  end

  def updateAccountJson new_password
    @accountData["account"]["password"] = new_password
    # json writer
    JsonController.jsonWriter JsonSettings::ACCOUNT_PATH, @accountData
    # json viewer
    data = JsonController.jsonReader JsonSettings::ACCOUNT_PATH
    JsonController.jsonViewer data
  end

  def updateBackupJson new_password
    dataExistedFlag = checkNew_passwordInBackupDataPasswordsList new_password
    if dataExistedFlag
      puts "the password exists in the data_backup"
    else
      # 新增密碼到備份密碼
      new_data = {
        "number"=> @backupData["account_passwords"].size,
        "password"=> new_password
      }
      @backupData["length"] += 1
      @backupData["account_passwords"].push new_data
      # json writer
      JsonController.jsonWriter JsonSettings::PASSWORDS_BACKUP_PATH, @backupData
      # json viewer
      data = JsonController.jsonReader JsonSettings::PASSWORDS_BACKUP_PATH
      JsonController.jsonViewer data
    end
  end
  # 檢查新密碼是否存在於備份密碼中
  def checkNew_passwordInBackupDataPasswordsList new_password
    dataExistedFlag = false
    for i in 0...@backupData["length"]
      if new_password == @backupData["account_passwords"][i]["password"]
        dataExistedFlag = true
        return dataExistedFlag
      end
    end
    return dataExistedFlag
  end
end

if __FILE__ == $0 
  new_password = "edcbaEDCBA4321"
  update = Update_Of_Json.new
  update.updateAccountJson new_password
  update.updateBackupJson new_password
end