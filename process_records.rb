require_relative "lib/processors/congressional_record"
require "base64"

source = Processors::CongressionalRecord.new(
  # https://www.benjaminfleischer.com/a-tour-of-string-encoding-errors
  ARGF.read.encode("utf-8", invalid: :replace, replace: "–")
)

pages = source.pages.map.with_index do |page, page_index|
        lines = page.lines

        max_size = lines.map {|l| l.length}.max
        grid = Array.new(max_size || 0, 0)

        lines.each do |line|
            line.chars.each_with_index do |c, index|
                grid[index] += 1 unless c == " "
            end
        end

        grid_copy = grid[1..-1] + [0] rescue []
        changes = minus(grid_copy, grid)

        spacing_a = (changes.index(changes.max) || 0)
        spacing_b = (changes.index(changes.max) || 0)

	      spaces = {}
	      grid.each_with_index { |number, index|
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

        if (180..190).include? page_index
          puts "#{page_index}:\t#{spaces.inspect}"
        end
        
        column_a = []
        column_b = []
        column_c = []

        lines.each do |line|
            column_a << (line.chars[0..spacing_a        ] || []).join
            column_b << (line.chars[spacing_a..spacing_b] || []).join
            column_c << (line.chars[spacing_b..-1       ] || []).join
        end

        grid_nums = grid.map{|x|
'0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'[x] || '~'
}.join + "\n"

        [lines].join("\n") # , grid_nums
        # [column_a, column_b].flatten.join("\n")
end

puts pages.join("- " * 80)
