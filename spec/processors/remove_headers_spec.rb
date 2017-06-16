require "processors/remove_headers"

describe Processors::RemoveHeaders do
  it "removes exact matches for the header" do
    header = "FRA17032   S.L.C.\n"

    document = <<-DOC
      FRA17032   S.L.C.
      Some text
      FRA17032   S.L.C.
      Some more text
    DOC

    expect(Processors::RemoveHeaders.process(document)).to eq(<<-DOC)
      Some text
      Some more text
    DOC
  end

  it "removes variations on the header with different whitespace" do
    document = <<-DOC
      FRA17032   S.L.C.
      Some text
      FRA17032      S.L.C.
      Some more text
    DOC

    expect(Processors::RemoveHeaders.process(document)).to eq(<<-DOC)
      Some text
      Some more text
    DOC
  end

  it "does not remove lines with non-header content" do
    document = <<-DOC
      FRA17032   S.L.C.
      Some text
      Something else   FRA17032   S.L.C.
      Some more text
    DOC

    expect(Processors::RemoveHeaders.process(document)).to eq(<<-DOC)
      Some text
      Something else   FRA17032   S.L.C.
      Some more text
    DOC
  end

  it "Only identifies headers of the format AAA#####" do
    document = <<-DOC
      II
      Some text
      Section II
      Some more text
    DOC

    expect(Processors::RemoveHeaders.process(document)).to eq(<<-DOC)
      II
      Some text
      Section II
      Some more text
    DOC
  end
end
