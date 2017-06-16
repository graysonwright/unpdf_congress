require "processors/remove_line_numbers"

describe Processors::RemoveLineNumbers do
  it "removes line numbers" do
    expect(Processors::RemoveLineNumbers.process(<<-DOC)).
      Some intro text without line numbers

 1      Be it enacted by the Senate and House of Representa-
 2 tives of the United States of America in Congress assembled,
 3  SECTION 1. SHORT TITLE.
    DOC
    to eq(<<-DOC)
      Some intro text without line numbers

     Be it enacted by the Senate and House of Representa-
tives of the United States of America in Congress assembled,
 SECTION 1. SHORT TITLE.
    DOC
  end
end
