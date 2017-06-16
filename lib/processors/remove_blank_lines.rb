require_relative "base"

module Processors
  class RemoveBlankLines < Base
    def processed_text
      text.gsub("\n\n", "\n")
    end
  end
end
