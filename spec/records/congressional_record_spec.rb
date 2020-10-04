require "processors/congressional_record"

describe Processors::CongressionalRecord do
  describe "#ordered_sources" do
    it "sorts non-padded-numbered sources" do
      record = Processors::CongressionalRecord.new([
        "crec-1.html",
        "crec-11.html",
        "crec-2.html",
        "crec-22.html",
      ])

      expect(record.ordered_sources).to eq([
        "crec-1.html",
        "crec-2.html",
        "crec-11.html",
        "crec-22.html",
      ])
    end
  end
end
