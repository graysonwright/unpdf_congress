require "processors/regroup_misplaced_characters"

describe Processors::RegroupMisplacedCharacters do
  it "regroups words where the first character has been attached to the preceding word" do
    expect(Processors::RegroupMisplacedCharacters.process(<<-DOC)).
      ‘‘(b) RANTS T OE NHANCE THE  PROVISION OFA DULT PROTECTIVE SERVICES.—
      (c) REQUIREMENTS  RELATING TO ELIGIBILITYB ASED ON DATA EXCHANGES .—
      ‘‘(a)DEVELOPMENT OF  CORE SET OFH EALTH CARE QUALITYM EASURES FOR ADULTS ELIGIBLE FORBENEFITS UNDER MEDICAID.
      FELLOWSHIPS REGARDINGF ACULTY POSITIONS
      ADDRESSH EALTH PROFESSIONS WORKFORCE NEEDS
    DOC
    to eq(<<-DOC)
      ‘‘(b) RANTS T O ENHANCE THE PROVISION OF ADULT PROTECTIVE SERVICES.—
      (c) REQUIREMENTS RELATING TO ELIGIBILITY BASED ON DATA EXCHANGES .—
      ‘‘(a)DEVELOPMENT OF CORE SET OF HEALTH CARE QUALITY MEASURES FOR ADULTS ELIGIBLE FORBENEFITS UNDER MEDICAID.
      FELLOWSHIPS REGARDING FACULTY POSITIONS
      ADDRESS HEALTH PROFESSIONS WORKFORCE NEEDS
    DOC
  end

  it "doesn't get tripped up on lines starting with non-words" do
    expect(Processors::RegroupMisplacedCharacters.process(<<-DOC)).
      >    Mr. YDEN introduced the following bill;
    DOC
    to eq(<<-DOC)
      >    Mr. YDEN introduced the following bill;
    DOC
  end

  it "handles multiple regroupings in a row" do
    expect(Processors::RegroupMisplacedCharacters.process(<<-DOC)).
      (c) EXTENSION OF PRESCRIPTION DRUG  DISCOUNTS TO ENROLLEES OF  M EDICAIDM ANAGED  CARE O RGANIZATIONS.—
    DOC
    to eq(<<-DOC)
      (c) EXTENSION OF PRESCRIPTION DRUG DISCOUNTS TO ENROLLEES OF M EDICAID MANAGED CARE O RGANIZATIONS.—
    DOC
  end

  it "recognizes and preserves special words (e.g., 'et')" do
    expect(Processors::RegroupMisplacedCharacters.process(<<-DOC)).
      The Religious Freedom Restoration Act of 1993 (42 U.S.C. 2000bb et seq.)
    DOC
    to eq(<<-DOC)
      The Religious Freedom Restoration Act of 1993 (42 U.S.C. 2000bb et seq.)
    DOC
  end
end
