require "processors/join_orphaned_characters"

describe Processors::JoinOrphanedCharacters do
  it "joins words that have an orphaned first character" do
    expect(Processors::JoinOrphanedCharacters.process(<<-DOC)).
      (a) S  HORT   TITLE .
      (b) TABLE OF   C ONTENTS .
    DOC
    to eq(<<-DOC)
      (a) SHORT   TITLE .
      (b) TABLE OF   CONTENTS .
    DOC
  end

  it "honors dashes as word barriers" do
    expect(Processors::JoinOrphanedCharacters.process(<<-DOC)).
      ‘‘PART A—I NDIVIDUAL AND GROUP MARKET REFORMS
      PART I—P  REMIUM  TAX CREDITS AND  COST-SHARING  REDUCTIONS
    DOC
    to eq(<<-DOC)
      ‘‘PART A—INDIVIDUAL AND GROUP MARKET REFORMS
      PART I—PREMIUM  TAX CREDITS AND  COST-SHARING  REDUCTIONS
    DOC
  end

  it "joins words that look like they have an 'a' article, but are plural" do
    expect(Processors::JoinOrphanedCharacters.process(<<-DOC)).
      A GENTS
    DOC
    to eq(<<-DOC)
      AGENTS
    DOC
  end

  it "prefers to join even if the main word stands on its own" do
    expect(Processors::JoinOrphanedCharacters.process(<<-DOC)).
      C ARE
    DOC
    to eq(<<-DOC)
      CARE
    DOC
  end

  it "recognizes invalid main words even if they are acronyms" do
    expect(Processors::JoinOrphanedCharacters.process(<<-DOC)).
      (d) RICS ALLOWED  N ET OPERATING  LOSS DEDUCTION.—
    DOC
    to eq(<<-DOC)
      (d) RICS ALLOWED  NET OPERATING  LOSS DEDUCTION.—
    DOC
  end

  it "joins words that `aspell` doesn't necessarily recognize" do
    expect(Processors::JoinOrphanedCharacters.process(<<-DOC)).
      DATA ON RURAL U NDERSERVED  POPULATIONS
    DOC
    to eq(<<-DOC)
      DATA ON RURAL UNDERSERVED  POPULATIONS
    DOC
  end

  it "joins words that `aspell` doesn't necessarily recognize" do
    expect(Processors::JoinOrphanedCharacters.process(<<-DOC)).
      (d) COORDINATION  WITH DERIVATIVE AND  S TRADDLE RULES .
    DOC
    to eq(<<-DOC)
      (d) COORDINATION  WITH DERIVATIVE AND  STRADDLE RULES .
    DOC
  end

  it "defers to later words when it is ambiguous" do
    expect(Processors::JoinOrphanedCharacters.process(<<-DOC)).
      (c) O N EGATIVE  INFERENCE
    DOC
    to eq(<<-DOC)
      (c) O NEGATIVE  INFERENCE
    DOC
  end

  specify "special case" do
    expect(Processors::JoinOrphanedCharacters.process(<<-DOC)).
      (d) COORDINATION  WITH DERIVATIVE AND  S TRADDLE RULES .
    DOC
    to eq(<<-DOC)
      (d) COORDINATION  WITH DERIVATIVE AND  STRADDLE RULES .
    DOC
  end

  specify "special case" do
    expect(Processors::JoinOrphanedCharacters.process(<<-DOC)).
      (b) PROHIBITION ON   DISCRIMINATION OR  S EGREGATION UNDER  LAW .—Section 202 of such Act (42 U.S.C. 2000a–1) is amended by inserting ‘‘sex, sexual orientation, gender identity,’’ before ‘‘or national origin’’.
    DOC
    to eq(<<-DOC)
      (b) PROHIBITION ON   DISCRIMINATION OR  SEGREGATION UNDER  LAW .—Section 202 of such Act (42 U.S.C. 2000a–1) is amended by inserting ‘‘sex, sexual orientation, gender identity,’’ before ‘‘or national origin’’.
    DOC
  end

  specify "special case" do
    expect(Processors::JoinOrphanedCharacters.process(<<-DOC)).
      AMENDMENT TO   DEFINITION OF SPECIFIED U NLAWFUL  ACTIVITY
    DOC
    to eq(<<-DOC)
      AMENDMENT TO   DEFINITION OF SPECIFIED UNLAWFUL  ACTIVITY
    DOC
  end

  specify "special case" do
    expect(Processors::JoinOrphanedCharacters.process(<<-DOC)).
      for a period of up to three years
    DOC
    to eq(<<-DOC)
      for a period of up to three years
    DOC
  end

  specify "special case" do
    expect(Processors::JoinOrphanedCharacters.process(<<-DOC)).
      parts A and B in the same manner
    DOC
    to eq(<<-DOC)
      parts A and B in the same manner
    DOC
  end

  specify "special case" do
    expect(Processors::JoinOrphanedCharacters.process(<<-DOC)).
      experts in women's and pediatric health
    DOC
    to eq(<<-DOC)
      experts in women's and pediatric health
    DOC
  end

  specify "special case" do
    expect(Processors::JoinOrphanedCharacters.process(<<-DOC)).
      the criteria for category B are as follows:
      the criteria for category C are as follows:
      the criteria for category D are as follows:
      the criteria for category F are as follows:
      the criteria for category H are as follows:
      the criteria for category M are as follows:
      the criteria for category P are as follows:
      the criteria for category R are as follows:
      the criteria for category T are as follows:
      the criteria for category W are as follows:
    DOC
    to eq(<<-DOC)
      the criteria for category B are as follows:
      the criteria for category C are as follows:
      the criteria for category D are as follows:
      the criteria for category F are as follows:
      the criteria for category H are as follows:
      the criteria for category M are as follows:
      the criteria for category P are as follows:
      the criteria for category R are as follows:
      the criteria for category T are as follows:
      the criteria for category W are as follows:
    DOC
  end

  specify "special case" do
    expect(Processors::JoinOrphanedCharacters.process(<<-DOC)).
      by redesignating part G as part F
      by redesignating part H as part G
    DOC
    to eq(<<-DOC)
      by redesignating part G as part F
      by redesignating part H as part G
    DOC
  end

  specify "special case" do
    expect(Processors::JoinOrphanedCharacters.process(<<-DOC)).
      PERMITTING A LL SOLE COMMUNITY HOSPITALS
    DOC
    to eq(<<-DOC)
      PERMITTING ALL SOLE COMMUNITY HOSPITALS
    DOC
  end
end
