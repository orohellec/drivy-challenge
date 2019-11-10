module HelperModule
  def write_outpout_in_json_file(fileName, output)
    open(fileName, 'w') do |f|
      f << JSON.pretty_generate(output)
    end
  end
end