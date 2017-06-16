require_relative "base"

module Processors
  class RemoveHeaders < Base
    HEADER_FORMAT = /[A-Z]{3}\d{5}/
    LINE_NUMBER_FORMAT = /^\s*\d+\s*$/

    def processed_text
      lines = text.lines

      if !(lines.first =~ HEADER_FORMAT)
        text
      else
        # Construct a regular expression out of the header
        # to handle whitespace variations
        header = lines.first.gsub(/ +/, '\s+')

        acceptable_lines = []

        line_index = 0
        while line_index < lines.count
          if(lines[line_index] =~ /^#{header}$/)
            # found a header!
            # now let's look for a line number immediately following it

            if(lines[line_index+1] =~ LINE_NUMBER_FORMAT)
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
    end
  end
end
