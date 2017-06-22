require_relative "base"

module Processors
  class SeparateSections < Base
    SECTION_MARKER_PREFIXES = "\u2018*"
    ROMAN_NUMERAL_CHARACTERS = "[ivxlcmIVXLCM]*"

    LEVEL_0_MARKER = /^\s*#{SECTION_MARKER_PREFIXES}(SECTION|SEC\.) \d+/u
    LEVEL_1_MARKER = /^\s*#{SECTION_MARKER_PREFIXES}\([a-zA-Z0-9]+\)/
    LEVEL_2_MARKER = /^\s*#{SECTION_MARKER_PREFIXES}PART #{ROMAN_NUMERAL_CHARACTERS}/
    LEVEL_3_MARKER = /^\s*#{SECTION_MARKER_PREFIXES}\(#{ROMAN_NUMERAL_CHARACTERS}\)/

    MARKERS = [
      LEVEL_0_MARKER,
      LEVEL_1_MARKER,
      LEVEL_2_MARKER,
      LEVEL_3_MARKER,
    ]

    BLOCKQUOTE = /^\>/

    def processed_text
      processed = []
      current_section = []

      text.lines.each.with_index do |line, index|
        if line.match(BLOCKQUOTE)
          # It's a quote. Don't mess with the spacing.
          # Instead, flush the `current_section`
          # and start adding the results directly to the processed text.
          processed << current_section.join(" ").gsub("\n", "")
          current_section = []

          processed << clean_line(line)
        elsif MARKERS.any? { |marker| line.match(marker) }
          # This line is the start of a new section
          # Join everything we've collected from the previous section
          # into the `processed` list,
          # so we can start working on the new section.
          processed << current_section.join(" ").gsub("\n", "")
          current_section = [line]
        elsif current_section.any?
          # We're in the middle of a section.
          # Join the current line into what we've already collected.
          current_section << line.strip
        else
          # We have not yet found the first section.
          processed << line.gsub("\n", "")
        end
      end

      processed << combine_lines(current_section)
      processed = processed - [""]

      processed.join("\n") + "\n"
    end

    private

    def combine_lines(lines)
      lines.map(&method(:clean_line)).join(" ")
    end

    def clean_line(line)
      line.gsub("\n", "")
    end
  end
end
