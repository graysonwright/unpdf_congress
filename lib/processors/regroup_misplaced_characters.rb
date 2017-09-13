require_relative "base"
require "ffi/aspell"

module Processors
  class RegroupMisplacedCharacters < Base
    NONRECOGNIZED_WORDS = []
    RECOGNIZED_WORDS = [
      "et",
    ]

    def processed_text
      lines = text.lines

      lines.map do |line|
        leading = line.match(/^\s*\>?\s*/).to_s
        remainder = line[leading.length..-1]

        words = remainder.split

        processed_words = []

        words.count.times do |word_index|
          word = words[word_index]
          next_word = words[word_index + 1]

          if valid?(word)
            processed_words << word
          elsif next_word && !valid?(next_word)
            # both this word and the following word are invalid.
            # Try to move the last letter of the word onto the next word,
            # and see if it fixes the problem.

            first_word_last_letter = word[-1]
            new_first_word = word[0...-1]
            new_next_word = first_word_last_letter + next_word

            if valid?(new_next_word)
              debug "found words to regroup: `#{word} #{next_word}` => `#{new_first_word} #{new_next_word}`"
              processed_words << new_first_word
              words[word_index + 1] = new_next_word
            else
              processed_words << word
            end
          else
            processed_words << word
          end
        end

        leading + processed_words.join(" ")
      end.join("\n") + "\n"
    end

    private

    def valid?(word)
      !NONRECOGNIZED_WORDS.include?(word.downcase) && (
        speller.correct?(word.downcase) ||
        RECOGNIZED_WORDS.include?(word.downcase)
      )
    end

    def speller
      @speller ||= FFI::Aspell::Speller.new("en_US", encoding: "utf-8")
    end

    def debug(string = nil)
      # puts string
    end
  end
end
