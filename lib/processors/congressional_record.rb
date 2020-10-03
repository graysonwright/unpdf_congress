

def minus(a, b)
    c = []
    a.each_with_index do |_, index|
        c << a[index] - b[index]
    end
    c
end

module Processors
  class CongressionalRecord
    class Region
    end

    class Page
      def initialize(source)
        @source = source
      end

      attr_accessor :source

      def lines
        source.lines
      end

      def pull_tables
        source.
          scan(/(?<=as follows:\n)[\w\-`:\s]+(?:.+\.{6,}.+\s+)+/).
          map.with_index {|table, index| [index, table.rstrip] }.
	  to_h
      end
    end
  end

  class CongressionalRecord
    def initialize(source)
      @source = source
    end

    attr_accessor :source

    def pages
      source.
        split(/^ *VerDate.+Jkt.+PO.+Frm.+Fmt.+Sfmt.+$/).
        map {|x| Page.new(x) }
    end

    def minus_blank_lines
      (source.split("\n") - [""]).join("\n")
    end
  end
end
