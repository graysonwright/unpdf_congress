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

  it "looks up words from the known corrections list" do
    expect(Processors::CompleteFirstWords.process(<<-DOC)).
      (c) O N EGATIVE  INFERENCE
    DOC
    to eq(<<-DOC)
      (c) NO N EGATIVE  INFERENCE
    DOC
  end
end
