require "processors/join_hyphenated_words"

describe Processors::JoinHyphenatedWords do
  it "joins words that have a hyphen" do
    expect(Processors::JoinHyphenatedWords.process(<<-DOC)).
      (7) Both LGBT people and women face wide- spread discrimination in employment and various services, including by entities that receive Federal fi - nancial assistance. Such discrimination—
    DOC
    to eq(<<-DOC)
      (7) Both LGBT people and women face widespread discrimination in employment and various services, including by entities that receive Federal financial assistance. Such discrimination—
    DOC
  end

  it "joins across (party) lines" do
    expect(Processors::JoinHyphenatedWords.process(<<-DOC)).
     Be it enacted by the Senate and House of Representa-
     tives of the United States of America in Congress assembled,
   DOC
   to eq(<<-DOC)
     Be it enacted by the Senate and House of Representatives of the United States of America in Congress assembled,
   DOC
  end

  it "respects words that should be hyphenated" do
    expect(Processors::JoinHyphenatedWords.process(<<-DOC)).
      ‘‘(B) S ECTION    988  HEDGING   TRANS   - ACTIONS .—For exception for section 988 hedg- ing transactions, see section 988(d)(1).
        ‘‘(3) SECURITIES LENDING   ,SALE -REPURCHASE  , AND SIMILAR FINANCING TRANSACTIONS       .—To the extent provided by the Secretary, for purposes of this part, the term ‘derivative’ shall not include the right to the return of the same or substantially iden- tical securities transferred in a securities lending transaction, sale-repurchase transaction, or similar financing transaction.
    DOC
    to eq(<<-DOC)
      ‘‘(B) S ECTION    988  HEDGING   TRANSACTIONS .—For exception for section 988 hedging transactions, see section 988(d)(1).
        ‘‘(3) SECURITIES LENDING   ,SALE-REPURCHASE  , AND SIMILAR FINANCING TRANSACTIONS       .—To the extent provided by the Secretary, for purposes of this part, the term ‘derivative’ shall not include the right to the return of the same or substantially identical securities transferred in a securities lending transaction, sale-repurchase transaction, or similar financing transaction.
    DOC
  end

  it "respects number-unit combinations" do
    expect(Processors::JoinHyphenatedWords.process(<<-DOC)).
    (b) IDENTIFICATION   REQUIREMENTS   .—If, as of the close of the 90-day period described in subsection (a)(1),
    DOC
    to eq(<<-DOC)
    (b) IDENTIFICATION   REQUIREMENTS   .—If, as of the close of the 90-day period described in subsection (a)(1),
    DOC
  end

  it "matches words that have multiple hyphens" do
    expect(Processors::JoinHyphenatedWords.process(<<-DOC)).
      out-of-pocket
    DOC
    to eq(<<-DOC)
      out-of-pocket
    DOC
  end
end
