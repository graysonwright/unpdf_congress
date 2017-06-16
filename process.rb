require "pdf-reader"

INPUT_DIRECTORY = "examples"
OUTPUT_DIRECTORY = "output"

input_files = Dir.glob("#{INPUT_DIRECTORY}/*.pdf")

input_files.each do |input_file|
  pdf = PDF::Reader.new(input_file)

  output = pdf.pages.map(&:text).join("\n")

  output_filename = input_file.
    gsub(INPUT_DIRECTORY, OUTPUT_DIRECTORY).
    gsub(/.pdf$/, ".txt")

  File.write(output_filename, output)
end
