module ActiveMocker
# @api private
class FileReader

  def self.read(file_and_path)
    File.open(file_and_path).read
  end

end

  private_constant :FileReader
end