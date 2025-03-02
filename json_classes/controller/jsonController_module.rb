require "json"

module JsonController
  def JsonController.jsonReader path
    data = File.read path
    data = JSON.parse data
    return data
  end

  def JsonController.jsonWriter path, data
    File.open path, 'w' do |f|
      f.write JSON.pretty_generate data, :indent => "\t"
    end
  end

  def JsonController.jsonViewer data
    puts JSON.pretty_generate(data)
  end
end