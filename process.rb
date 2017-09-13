require "pdf-reader"
require "ruby-progressbar"

require_relative "lib/processors/complete_first_words"
require_relative "lib/processors/join_hyphenated_words"
require_relative "lib/processors/join_orphaned_characters"
require_relative "lib/processors/regroup_misplaced_characters"
require_relative "lib/processors/remove_blank_lines"
require_relative "lib/processors/remove_headers"
require_relative "lib/processors/remove_line_numbers"
require_relative "lib/processors/separate_sections"

INPUT_DIRECTORY = "examples"
OUTPUT_DIRECTORY = "output"

input_files = Dir.glob("#{INPUT_DIRECTORY}/*.pdf")

puts "Processing #{input_files.count} files"

input_files.each do |input_file|
  pdf = PDF::Reader.new(input_file)

  progress = ProgressBar.create(
    format: "%t:  |%w>%i| %c/%C pages, %e",
    starting_at: 0,
    title: "Parsing #{input_file}",
    total: pdf.page_count,
  )

  output = pdf.pages.map do |page|
    progress.increment
    page.text
  end.join("\n")

  print "Processing...\t"

  output = Processors::RemoveBlankLines.process(output)
  output = Processors::RemoveHeaders.process(output)
  output = Processors::RemoveLineNumbers.process(output)
  output = Processors::SeparateSections.process(output)
  output = Processors::JoinHyphenatedWords.process(output)
  output = Processors::RegroupMisplacedCharacters.process(output)
  output = Processors::JoinOrphanedCharacters.process(output)
  output = Processors::CompleteFirstWords.process(output)
  output = Processors::JoinHyphenatedWords.process(output)

  puts "Done"
  puts

  output_filename = input_file.
    gsub(INPUT_DIRECTORY, OUTPUT_DIRECTORY).
    gsub(/.pdf$/, ".txt")

  File.write(output_filename, output)
end
