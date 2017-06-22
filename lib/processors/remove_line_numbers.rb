require_relative "base"

module Processors
  class RemoveLineNumbers < Base
    def processed_text
      text.lines.map do |line|
        number = line.slice!(/^ ?\d+ /)

        if number
          line
        elsif line.strip != ""
          # This line doesn't have a line number.
          # Add a blockquote to the line to make sure we don't mess with it later.
          "> " + line
        else
          line
        end
      end.join
    end
  end
end
