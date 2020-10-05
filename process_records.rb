require_relative "lib/processors/congressional_record"

source = Processors::CongressionalRecord.new(
  Dir.glob("compiled/*.html")
)

beginning = 310
source.pages[beginning..-1].each.with_index do |page, index|
  puts "- - - - - pdf page #{index + beginning} - - - - -"
  puts page.lines
end

# special pages
# 184 has grids
# 325, 326, 327 has roll calls
# 528, 569 has subcolumn grids
