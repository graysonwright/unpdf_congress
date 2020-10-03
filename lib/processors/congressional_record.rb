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

      def as_single_column
        source
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

      def as_single_column
=begin
        column_a = []
        column_b = []
        column_c = []

        lines.each do |line|
            column_a << (line.chars[0..spacing_a        ] || []).join
            column_b << (line.chars[spacing_a..spacing_b] || []).join
            column_c << (line.chars[spacing_b..-1       ] || []).join
        end

        grid_nums = column_grid.map{|x|
'0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'[x] || '~'
}.join + "\n"

=end
        [lines].join("\n") # , grid_nums
        # [column_a, column_b, column_c].flatten.join("\n")
      end

      def column_grid
        max_size = lines.map {|l| l.length}.max
        grid = Array.new(max_size || 0, 0)

        lines.each do |line|
            line.chars.each_with_index do |c, index|
                grid[index] += 1 unless c == " "
            end
        end

        grid
      end

      def column_spacing
	      spaces = {0 => 0}

	      column_grid.each_with_index { |number, index|
            if number <= 5
                if (beginning = spaces.invert[index - 1])
                    spaces[beginning] = index
                else
                    spaces[index] = index
                end
            end
        }

        drop = []
        spaces.each {|beginning, ending| drop << beginning if ending - beginning < 2 }
        drop.each {|x| spaces.delete(x) }
        spaces
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
