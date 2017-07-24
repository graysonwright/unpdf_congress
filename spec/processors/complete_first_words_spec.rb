require "processors/complete_first_words"

describe Processors::CompleteFirstWords do
  it "leaves correct first words alone" do
    expect(Processors::CompleteFirstWords.process(<<-DOC)).
      (A) significant
    DOC
    to eq(<<-DOC)
      (A) significant
    DOC
  end

  it "fills in missing first letters in sections" do
    expect(Processors::CompleteFirstWords.process(<<-DOC)).
      (b) URPOSES
    DOC
    to eq(<<-DOC)
      (b) PURPOSES
    DOC
  end
end
