require_relative "lib/processors/congressional_record"

source = Processors::CongressionalRecord.new(
  Dir.glob("compiled/*.html")
)

source.pages[2..-1].each do |page|
  page.source.css("div > nobr").each do |line|
    puts line.text
  end
end

# special pages
# 184 has grids
# 325, 326, 327 has roll calls
# 528, 569 has subcolumn grids
