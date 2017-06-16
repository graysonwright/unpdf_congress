require_relative "base"

module Processors
  class RemoveHeaders < Base
    HOUSE_HEADER_FORMAT = /^\s*†?HR \d+/
    LINE_NUMBER_FORMAT = /^\s*\d+\s*$/
    SENATE_HEADER_FORMAT = /^\s*[A-Z]{3}\d{5}/

    def processed_text
      lines = text.lines
      acceptable_lines = []

      line_index = 0
      while line_index < lines.count
        if is_a_header?(lines[line_index])
          # we found a header!
          # now let's look for a line number immediately following it

          if lines[line_index+1].match(LINE_NUMBER_FORMAT)
            # the next line only contains a line number.
            # Jump ahead to skip it.
            line_index += 1
          end
        else
          acceptable_lines << lines[line_index]
        end

        line_index += 1
      end

      acceptable_lines.join
    end

    private

    def is_a_header?(line)
      line.match(SENATE_HEADER_FORMAT) ||
        line.match(HOUSE_HEADER_FORMAT)
    end
  end
end
