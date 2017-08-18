require_relative "base"

module Processors
  class JoinHyphenatedWords < Base
    # A list of hyphenated words,
    # where we do not want to remove the hyphens from the text.
    #
    # Wildcard characters:
    # \d - any digit (0-9)
    # \w - a word character (a-z, A-Z, _)
    VALID_HYPHENATED_WORDS = [
      '10-K',
      'Biggert-Waters',
      'Epidemiology-Laboratory Capacity Grants',
      'Health Care-Aquired',
      '\d+-day',
      '\d+-month',
      '\d+-point',
      '\d+-year',
      '\w+-assisted',
      '\w+-based',
      '\w+-by-\w+',
      '\w+-centered',
      '\w+-dependent',
      '\w+-driven',
      '\w+-enabled',
      '\w+-exempt',
      '\w+-for-\w+',
      '\w+-linked',
      '\w+-managed',
      '\w+-neutral',
      '\w+-of-\w+',
      '\w+-participating',
      '\w+-related',
      '\w+-run',
      '\w+-sharing',
      '\w+-shortage',
      '\w+-specific',
      '\w+-sponsored',
      '\w+-star',
      '\w+-the-\w+',
      '\w+-time',
      '\w+-to-\w+',
      'add-on',
      'built-in',
      'child-sex offenders',
      'co-locat\w+', # stem of co-locate
      'co-pay', # can't use `co-`, it's too common
      'co-chairperson', # can't use `co-`, it's too common
      'decision-making',
      'high-\w+',
      'in-office', # can't use `in-`; it's too common in non-hyphenated words
      'long-\w+',
      'low-\w+',
      'multi-\w+',
      'non-\w+',
      'nurse-midwife',
      'phase-in',
      'post-\w+',
      'sale-repurchase',
      'same-sex',
      'self-\w+',
      'short-term',
      'single-\w+',
      'third-party',
    ].freeze

    # This string is temporarily inserted into the document
    # to keep track of the places where we want to keep a hyphen in place.
    #
    # For examples, see the `VALID_HYPHENATED_WORDS` constant.
    HYPHEN_SUBSTITUTION_TOKEN = "KEYWORD_HYPHEN"

    INTRA_WORD_DASH = /\W*-\W*/.freeze

    def processed_text
      processed = text.gsub(INTRA_WORD_DASH, "-")
      processed = substitute_valid_hyphenated_words(processed)
      processed = processed.gsub(INTRA_WORD_DASH, "")
      processed = restore_hyphens_to_valid_words(processed)
    end

    private

    def substitute_valid_hyphenated_words(input)
      output = input

      VALID_HYPHENATED_WORDS.each do |word|
        # A regex to search for the hyphenated words that we want to keep:
        # * case-insensitive (the `i` option)
        # * saves the location of the hyphen as a numbered match (the parentheses)
        regex = /#{word.gsub("-", "(-)")}/i

        while match = output.match(regex)
          (1...match.length).each do |hyphen|
            index = hyphen - 1
            token_offset = HYPHEN_SUBSTITUTION_TOKEN.length - 1
            net_hyphen_offset = token_offset * index

            original_offset = match.offset(hyphen)
            before, after = original_offset.map { |x| x + net_hyphen_offset }
            output = output[0...before] + HYPHEN_SUBSTITUTION_TOKEN + output[after..-1]
          end
        end
      end

      output
    end

    def restore_hyphens_to_valid_words(input)
      input.gsub(HYPHEN_SUBSTITUTION_TOKEN, "-")
    end
  end
end
