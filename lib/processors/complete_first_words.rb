require_relative "base"
require_relative "separate_sections"
require "ffi/aspell"

module Processors
  class CompleteFirstWords < Base
    ALLOWED_NONENGLISH_WORDS = [
      "ACO",
      "CAPITATED",
      "CME",
      "HSA",
      "redesignating",
    ].freeze

    CORRECTIONS = {
      "ACIAL" => "RACIAL",
      "AIVER" => "WAIVER",
      "ARGE" => "LARGE",
      "ARTIAL" => "PARTIAL",
      "ASELINE" => "BASELINE",
      "ASSAGE" => "PASSAGE",
      "ATCHING" => "MATCHING",
      "ATENT" => "PATENT",
      "AYER" => "PAYER",
      "EACHING" => "TEACHING",
      "EAM" => "TEAM",
      "EARING" => "HEARING",
      "EBASING" => "REBASING",
      "EBATE" => "REBATE",
      "EES" => "FEES",
      "EFERENCE" => "REFERENCE",
      "ELIGIBLES" => "ELIGIBLE S",
      "ENSE" => "SENSE",
      "EPORT" => "REPORT",
      "EPORTING" => "REPORTING",
      "EPORTS" => "REPORTS",
      "ERM" => "TERM",
      "ERMINATION" => "TERMINATION",
      "ERMS" => "TERMS",
      "ERVICES" => "SERVICES",
      "ESS" => "LESS",
      "ESTING" => "TESTING",
      "EVELS" => "LEVELS",
      "EW" => "NEW",
      "FFECT" => "EFFECT",
      "HASE" => "PHASE",
      "IFE" => "LIFE",
      "IME" => "TIME",
      "IMES" => "TIMES",
      "IMING" => "TIMING",
      "IMPLE" => "SIMPLE",
      "INGLE" => "SINGLE",
      "ISK" => "RISK",
      "IST" => "LIST",
      "LANS" => "PLANS",
      "LOOD" => "FLOOD",
      "NG" => "IN G",
      "NTRA" => "INTRA",
      "O" => "NO",
      "OCAL" => "LOCAL",
      "ONG" => "LONG",
      "ONGSHORE" => "LONGSHORE",
      "ORM" => "FORM",
      "OSS" => "LOSS",
      "OST" => "COST",
      "OSTING" => "POSTING",
      "OTING" => "VOTING",
      "OTION" => "MOTION",
      "OWERS" => "POWERS",
      "RAL" => "ORAL",
      "THER" => "OTHER",
      "UALITY" => "QUALITY",
      "ULE" => "RULE",
      "ULES" => "RULES",
      "ULL" => "FULL",
      "URSING" => "NURSING",
      "UTIES" => "DUTIES",
    }.freeze

    def processed_text
      text.lines.map do |line|
        section_heading, section = parse_section(line)
        first_word = section.to_s.split.first

        if(section_heading && first_word)
          unless valid?(first_word)
            suggestion = speller.suggestions(first_word).find do |word|
              word.end_with?(first_word)
            end

            replacement = CORRECTIONS.fetch(first_word, suggestion)

            if(replacement)
              section.sub!(first_word, replacement)
            end
          end

          [section_heading, section].join
        else
          line
        end
      end.join
    end

    private

    def valid?(word)
      !CORRECTIONS.keys.include?(word) && (
        speller.correct?(word) ||
        ALLOWED_NONENGLISH_WORDS.include?(word)
      )
    end

    def parse_section(line)
      Processors::SeparateSections::MARKERS.each do |marker|
        match = line.match(marker)

        if match
          return [match.to_s, match.post_match]
        end
      end

      return [nil, nil]
    end

    def speller
      @speller ||= FFI::Aspell::Speller.new("en_US", encoding: "utf-8")
    end
  end
end
