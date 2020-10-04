require "nokogiri"

module Processors
  class CongressionalRecord
    class Page
      def initialize(source)
        @source = Nokogiri::HTML(File.read(source))
      end

      attr_accessor :source
    end
  end

  class CongressionalRecord
    def initialize(sources)
      @sources = sources
    end

    attr_accessor :sources

    def pages
      @pages ||= ordered_sources.map {|s| Page.new(s) }
    end

    def ordered_sources
      sources.sort do |source_a, source_b|
        source_a.scan(/\d+/)[0].to_i <=> source_b.scan(/\d+/)[0].to_i
      end
    end
  end
end
