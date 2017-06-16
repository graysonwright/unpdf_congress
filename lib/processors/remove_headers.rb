require_relative "base"

module Processors
  class RemoveHeaders < Base
    HEADER_FORMAT = /[A-Z]{3}\d{5}/

    def processed_text
      header = text.lines.first

      if header =~ HEADER_FORMAT
        # Construct a regular expression out of the header
        # to handle whitespace variations
        header.gsub!(/ +/, '\s+')

        text.lines.reject do |line|
          line =~ /^#{header}$/
        end.join
      else
        text
      end
    end
  end
end
