require "processors/remove_headers"

describe Processors::RemoveHeaders do
  it "removes exact matches for the header" do
    expect(Processors::RemoveHeaders.process(<<-DOC)).
      FRA17032   S.L.C.
      Some text
      FRA17032   S.L.C.
      Some more text
    DOC
    to eq(<<-DOC)
      Some text
      Some more text
    DOC
  end

  it "removes variations on the header with different whitespace" do
    expect(Processors::RemoveHeaders.process(<<-DOC)).
      FRA17032   S.L.C.
      Some text
      FRA17032      S.L.C.
      Some more text
    DOC
    to eq(<<-DOC)
      Some text
      Some more text
    DOC
  end

  it "does not remove lines with non-header content" do
    expect(Processors::RemoveHeaders.process(<<-DOC)).
      FRA17032   S.L.C.
      Some text
      Something else   FRA17032   S.L.C.
      Some more text
    DOC
    to eq(<<-DOC)
      Some text
      Something else   FRA17032   S.L.C.
      Some more text
    DOC
  end

  it "Only identifies headers of the format AAA#####" do
    expect(Processors::RemoveHeaders.process(<<-DOC)).
      II
      Some text
      Section II
      Some more text
    DOC
    to eq(<<-DOC)
      II
      Some text
      Section II
      Some more text
    DOC
  end

  it "removes page numbers on lines immediately following the headers" do
    expect(Processors::RemoveHeaders.process(<<-DOC)).
      FRA17032      S.L.C.
      Some text
      FRA17032      S.L.C.
              2
      Some more text
      FRA17032      S.L.C.
              3
      Even more text
    DOC
    to eq(<<-DOC)
      Some text
      Some more text
      Even more text
    DOC
  end
end
