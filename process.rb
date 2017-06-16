require "pdf-reader"
require "benchmark"

INPUT_DIRECTORY = "examples"
OUTPUT_DIRECTORY = "output"

input_files = Dir.glob("#{INPUT_DIRECTORY}/*.pdf")

puts

input_files.each do |input_file|
  output_filename = input_file.
    gsub(INPUT_DIRECTORY, OUTPUT_DIRECTORY).
    gsub(/.pdf$/, ".txt")

  puts "Processing #{input_file}..."

  time = Benchmark.realtime do
    pdf = PDF::Reader.new(input_file)
    print "\t#{pdf.page_count} pages\t"
    output = pdf.pages.map(&:text).join("\n")

    File.write(output_filename, output)
  end

  puts "completed in #{'%2f' % time} seconds"
  puts
end
