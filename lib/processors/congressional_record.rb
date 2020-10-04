require "nokogiri"

module Processors
  class CongressionalRecord
    class Page
      def initialize(source)
        @source = Nokogiri::HTML(source)
      end

      attr_accessor :source

      def lines
        pulled_lines = []
        line_number = 0
        source.css("div > nobr").each do |line|
          number = line.parent.attributes["style"].value.scan(/top:(\d+)/)[0][0].to_i

          if number == line_number
            pulled_lines[-1] = pulled_lines[-1] + ' ' + line.text
          else
            pulled_lines << line.text
          end

          line_number = number
        end

        pulled_lines.map {|l| l + "\n" }
      end
    end
  end

  class CongressionalRecord
    def initialize(sources)
      @sources = sources
    end

    attr_accessor :sources

    def pages
      @pages ||= ordered_sources.map {|s| Page.new(File.read(s)) }
    end

    def ordered_sources
      sources.sort do |source_a, source_b|
        source_a.scan(/\d+/)[0].to_i <=> source_b.scan(/\d+/)[0].to_i
      end
    end
  end
end
