# frozen_string_literal: true
module ActiveMocker
  class FilePathToRubyClass
    attr_reader :class_path, :base_path

    def initialize(base_path:, class_path:)
      @base_path  = base_path
      @class_path = class_path
    end

    def to_s
      File.basename(class_path.gsub(base_path + "/", "").split("/").map(&:camelize).join("::"), ".rb")
    end
  end
end
