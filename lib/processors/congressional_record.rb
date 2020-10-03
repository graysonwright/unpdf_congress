

def minus(a, b)
    c = []
    a.each_with_index do |_, index|
        c << a[index] - b[index]
    end
    c
end

module Processors
  class CongressionalRecord
    class Grid
      def initialize(source)
        @source = source
      end

      attr_accessor :source

      def lines
        source.lines
      end
    end

    class Region
      def initialize(source)
        @source = source
      end

      attr_accessor :source

      def lines
        source.lines
      end
    end

    class Page
      def initialize(source)
        @source = source
      end

      attr_accessor :source

      def lines
        source.lines
      end

      def regions
        grids = pull_tables

        s = source
        regions = []

        i = 0
        while i < grids.length
          s = s.split(grids[i])
          regions << Region.new(s.shift)
          regions << Grid.new(grids[i])
          s = s[0]
          i += 1
        end
        regions << Region.new(s)

        regions
      end

      def pull_tables
        source.
          scan(/(?<=as follows:\n)[\w\-`:\s]+(?:.+\.{6,}.+\s+)+/)
          # map.with_index {|table, index| [index, table.rstrip] }.
	  # to_h
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
