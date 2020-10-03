require_relative "lib/processors/congressional_record"
require "base64"

source = Processors::CongressionalRecord.new(
  # https://www.benjaminfleischer.com/a-tour-of-string-encoding-errors
  ARGF.read.encode("utf-8", invalid: :replace, replace: "–")
)

pages = source.pages.map.with_index do |page, page_index|
  regions = page.regions

  # debug grid spacing; see uniquely-columned pages.
=begin
  if(page_index >= 325)
    puts page.regions.map.with_index {|r, index|
      "#{page_index}.#{index}\t#{r.respond_to?(:column_spacing) ? r.column_spacing.inspect : 'grid'}"
    }
  end
=end

  # special pages
  # 184 has grids
  # 325, 326, 327 has roll calls
  # 528, 569 has subcolumn grids
=begin
  if([325, 326, 327].include? page_index)
    File.write("#{page_index}.txt", page.source)
    puts page_index

    page.regions.each do |region|
      index_line = ' ' * region.source.lines.map(&:length).max
      if region.respond_to? :column_spacing
        region.column_spacing.each {|beginning, ending| index_line[beginning..ending] = '~' * (ending - beginning) }
      end
      puts index_line
      puts "|         " * 20
      puts region.source
    end
  end
=end

  regions.map(&:as_single_column)
end

puts pages.join("- " * 80)
