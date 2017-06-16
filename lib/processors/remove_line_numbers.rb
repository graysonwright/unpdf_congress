require_relative "base"

module Processors
  class RemoveLineNumbers < Base
    def processed_text
      text.lines.map do |line|
        line.slice!(/^ ?\d+ /)
        line
      end.join
    end
  end
end
