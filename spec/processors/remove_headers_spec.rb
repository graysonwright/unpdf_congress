require "processors/remove_headers"

describe Processors::RemoveHeaders do
  it "can locate headers that don't appear on the first line" do
    expect(Processors::RemoveHeaders.process(<<-DOC)).
      Some text
      FRA17032   S.L.C.
      Some more text
    DOC
    to eq(<<-DOC)
      Some text
      Some more text
    DOC
  end

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

  describe "header formats" do
    it "identifies senate-style headers, of the format ABC12345" do
      expect(Processors::RemoveHeaders.process(<<-DOC)).
        FRA17032   S.L.C.
        Some text
      DOC
      to eq(<<-DOC)
        Some text
      DOC
    end

    it "does not remove arbitrary strings that appear on the first line" do
      expect(Processors::RemoveHeaders.process(<<-DOC)).
        II
        Some text
      DOC
      to eq(<<-DOC)
        II
        Some text
      DOC
    end

    it "identifies house-style headers, of the format HR 1234" do
      expect(Processors::RemoveHeaders.process(<<-DOC)).
        †HR 757 EAS
        Some text
      DOC
      to eq(<<-DOC)
        Some text
      DOC
    end
  end
end
