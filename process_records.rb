require_relative "lib/processors/congressional_record"

source = Processors::CongressionalRecord.new(
  Dir.glob("compiled/*.html")
)

# special pages
# 184 has grids
# 325, 326, 327 has roll calls
# 528, 569 has subcolumn grids
