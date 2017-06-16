require "pdf-reader"
require "ruby-progressbar"

INPUT_DIRECTORY = "examples"
OUTPUT_DIRECTORY = "output"

input_files = Dir.glob("#{INPUT_DIRECTORY}/*.pdf")

puts "Processing #{input_files.count} files"

input_files.each do |input_file|
  pdf = PDF::Reader.new(input_file)

  progress = ProgressBar.create(
    format: "%t:  |%w>%i| %c/%C pages, %e",
    starting_at: 0,
    title: input_file,
    total: pdf.page_count,
  )

  output = pdf.pages.map do |page|
    progress.increment
    page.text
  end.join("\n")

  output_filename = input_file.
    gsub(INPUT_DIRECTORY, OUTPUT_DIRECTORY).
    gsub(/.pdf$/, ".txt")

  File.write(output_filename, output)
end
