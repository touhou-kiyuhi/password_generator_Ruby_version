$LOAD_PATH << '.'
require "json_classes/settings/jsonSettings_module.rb"
require "json_classes/controller/jsonController_module.rb"

class Password_Generator
  include JsonSettings
  include JsonController

  # Getter
  attr_reader :userName, :passwordsBackupElements, 
  :passwordList, :password, :passwordLength, :passwordLengthLimit, 
  :upperAlphabets, :lowerAlphabets, :numbers, :symbolsElements, :symbolsLength, :symbols

  @@RANDOM = Random.new 

  # Constructor
  def initialize
    # 使用者名稱、備份密碼 元素
    @account = JsonController.jsonReader JsonSettings::ACCOUNT_PATH
    @userName = ""
    @passwordsBackup = JsonController.jsonReader JsonSettings::PASSWORDS_BACKUP_PATH
    @passwordsBackupElements = []
    # 密碼
    @passwordList = []
    @password = ""
    # 密碼長度
    @passwordLength = 0
    # 長度至少為 14 個字元
    @passwordLengthLimit = 14
    # 英文大寫字元 (A 到 Z)：65 ~ 90
    @upperAlphabetsLength = 5
    @upperAlphabets = []
    # 英文小寫字元 (a 到 z)：97 ~ 122
    @lowerAlphabetsLength = 5
    @lowerAlphabets = []
    # 10 進位數字 (0 到 9)：48 ~ 57
    @numbersLength = 4
    @numbers = []
    # 非英文字母字元 (例如: !、$、#、%)：32 ~ 126 ，不包含 48 ~ 57 、 65 ~ 90 、 97 ~ 122
    @symbolsElements = (32..126).map(&:chr) - (48..57).map(&:chr) - (65..90).map(&:chr) - (97..122).map(&:chr)
    @symbolsLength = 0
    @symbols = []
  end

  private

  # Setter
  def setUserName
    @userName = @account["account"]["user"]
  end
  # 備份密碼元素
  def setPasswordsBackupElements
    for i in 0...@passwordsBackup["length"]
      password = @passwordsBackup["account_passwords"][i]["password"]
      @passwordsBackupElements.push password
    end
  end

  # 英文大寫字元 (A 到 Z)：65 ~ 90
  def setUpperAlphabets
    @upperAlphabets = generator @upperAlphabetsLength, @upperAlphabets, 65, 90
  end
  # 英文小寫字元 (a 到 z)：97 ~ 122
  def setLowerAlphabets
    @lowerAlphabets = generator @lowerAlphabetsLength, @lowerAlphabets, 97, 122
  end
  # 10 進位數字 (0 到 9)：48 ~ 57
  def setNumbers
    @numbers = generator @numbersLength, @numbers, 48, 57
  end
  # 非英文字母字元 (例如: !、$、#、%)：32 ~ 126 ，不包含 48 ~ 57 、 65 ~ 90 、 97 ~ 122
  def setSymbolsLength
    @symbolsLength = @passwordLength - @passwordLengthLimit
  end
  def setSymbols
    loop do
      for _ in 0...symbolsLength
        @symbols.push symbolsElements.at @@RANDOM.rand symbolsElements.size
      end
      break if checkCharactersNotTriplicate @symbols
      @symbols.clear
    end
  end

  # 密碼 
  def setPasswordList
    @passwordList = @lowerAlphabets + @upperAlphabets + @numbers + @symbols
  end
  def setPassword passwordLength
    # 密碼長度
    setPasswordLength passwordLength
    # 非英文字母字元長度
    setSymbolsLength

    # 使用者名稱、備份密碼 元素
    setUserName
    setPasswordsBackupElements
    loop do
      # 英文大寫字元 (A 到 Z)、英文小寫字元 (a 到 z)、10 進位數字 (0 到 9)、非英文字母字元 (例如: !、$、#、%)
      setUpperAlphabets
      setLowerAlphabets
      setNumbers
      
      setPasswordList
      @password = @passwordList.join(sep='')
      # 密碼不為空字串
      # 密碼中，不可包含帳號相關字眼
      # 確認密碼不存在於備份密碼中
      break if @password != "" && checkPasswordSubstringsNotInUserName && !@passwordsBackupElements.include?(@password)
    end
  end
  def setPasswordLength passwordLength
    @passwordLength = (passwordLength < @passwordLengthLimit) ? @passwordLengthLimit : passwordLength
  end
  
  # Others
  # 密碼中，不可包含帳號相關字眼
  def checkPasswordSubstringsNotInUserName
    for i in 0...@passwordLength - 3
      passwordSubstring = @password[i, i + 3]
      if @userName.include?(passwordSubstring)
        return false
      end
    end
    return true
  end
  def checkCharactersNotTriplicate lst
    # 建立 Map 計算字母出現次數
    lstMap = Hash.new
    lst.each do |c|
      if lstMap.empty? || lstMap[c] == nil
        lstMap.store c, 1
      else
        lstMap[c] += 1
      end
    end
    lstMap.each_key do |k|
      if lstMap[k] > 2
        return false
      end
    end
    return true
  end
  # 英文大寫字元 (A 到 Z)、英文小寫字元 (a 到 z)、10 進位數字 (0 到 9) 生成器
  def generator length, lst, rangeFirst, rangeLast
    loop do
      for _ in 0...length
        lst.push @@RANDOM.rand(rangeFirst..rangeLast).chr
      end
      break if checkCharactersNotTriplicate lst
      lst.clear
    end 
    return lst
  end

  public :setPassword
end

if __FILE__ == $0
  pwdGenerator = Password_Generator.new
  pwdGenerator.setPassword 14
  password = pwdGenerator.password
  puts password
end