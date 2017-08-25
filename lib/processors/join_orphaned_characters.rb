require_relative "base"
require "ffi/aspell"
require "active_support/inflector"
require "colorize"

module Processors
  class JoinOrphanedCharacters < Base
    ORPHAN_CHARACTER = /(?<=(?<preceding_delimiter>[\s\u2014])(?<orphan>[a-z]))\s+(?<main>\w+)/i

    NONRECOGNIZED_WORDS = [
      "ct",
      "ll",
      "ya",
    ]

    RECOGNIZED_WORDS = [
      "hawaiis",
      "healthcare",
      "korea",
      "multi",
      "outlier",
      "rebuttable",
      "underserved",
    ]

    ORDINAL_QUALIFIER_ROOTS = [
      "category",
      "chapter",
      "part",
      "subchapter",
      "title",
    ]

    ORDINAL_QUALIFIERS = (
      ORDINAL_QUALIFIER_ROOTS +
      ORDINAL_QUALIFIER_ROOTS.map(&:pluralize)
    )

    CONJUNCTIONS = [
      "and",
      "or",
    ].freeze

    def processed_text
      matches = text.enum_for(:scan, ORPHAN_CHARACTER).map { Regexp.last_match }
      processed_through_index = text.length

      debug "# Found #{matches.count} matches:"
      debug
      debug "Listed in reverse order – it's easier to process that way."
      debug

      # process them in reverse order
      # so we don't mess up the indices before we get to them
      matches.reverse.each_with_index do |match, line_number|
        orphan = match[:orphan]
        main = match[:main]
        preceding_delimiter = match["preceding_delimiter"]

        word = orphan + main

        start_index = match.begin(:orphan)
        end_index = match.end(:main)

        gap_length = match.begin(:main) - match.end(:orphan)

        already_processed = processed_through_index <= end_index
        ought_to_join = ought_to_join?(start_index, preceding_delimiter, orphan, main)

        if !already_processed && ought_to_join
          # Print result
          prefix = text[start_index - 40...start_index].to_s.lines.last
          contents = "#{orphan}#{'=' * gap_length}#{main}"
          suffix = text[end_index...end_index + 20].to_s.lines.first

          debug_line(line_number, "JOIN", prefix, contents, suffix, :red)

          # Execute result
          text[start_index...end_index] = word
          processed_through_index = start_index
        else
          # Print result
          prefix = text[start_index - 40...start_index].to_s.lines.last
          contents = "#{orphan}#{' ' * gap_length}#{main}"
          suffix = text[end_index...end_index + 20].to_s.lines.first

          debug_line(line_number, "PASS", prefix, contents, suffix, :blue)
        end
      end

      text
    end

    private

    def ought_to_join?(start_index, preceding_delimiter, orphan, main)
      full_word = [orphan, main].join.downcase

      just_an_article = (
        orphan.downcase == "a" &&
        valid?(main.downcase) &&
        singular?(main.downcase)
      )

      possessive = (
        preceding_delimiter == "’" &&
        orphan.downcase == "s"
      )

      (
        !just_an_article &&
        !possessive &&
        !ordinal?(start_index) &&
        valid?(full_word)
      )
    end

    def ordinal?(start_index)
      # Look back at least 20 characters to see if there's an ordinal qualifier
      lookback = 20 + ORDINAL_QUALIFIERS.map(&:length).max

      origin = [0, start_index - lookback].max
      preceding_words = text[origin...start_index].split.reverse

      preceding_word = preceding_words.shift

      while preceding_word && CONJUNCTIONS.include?(preceding_word)
        _conjoined = preceding_words.shift
        preceding_word = preceding_words.shift
      end

      preceding_word && ORDINAL_QUALIFIERS.include?(preceding_word)
    end

    def valid?(word)
      !NONRECOGNIZED_WORDS.include?(word) &&
        (speller.correct?(word) || RECOGNIZED_WORDS.include?(word))
    end

    def singular?(word)
      word.pluralize != word && word.singularize == word
    end

    def speller
      @speller ||= FFI::Aspell::Speller.new("en_US", encoding: "utf-8")
    end

    def debug(string = nil)
      # puts string
    end

    def debug_line(line_number, heading, prefix, contents, suffix, color)
      debug "(ln \#\t#{line_number}) #{heading}: #{prefix}#{contents.colorize(color)}#{suffix}"
    end
  end
end
