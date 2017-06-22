require "processors/separate_sections"

describe Processors::SeparateSections do
  it "identifies sections marked by the 'SECTION' keyword" do
    expect(Processors::SeparateSections.process(<<-DOC)).
 ‘‘SECTION 494. TAX TREATMENT OF CONTRACTS SIMILAR TO
              DERIVATIVES.
    DOC
    to eq(<<-DOC)
 ‘‘SECTION 494. TAX TREATMENT OF CONTRACTS SIMILAR TO DERIVATIVES.
    DOC
  end

  it "identifies sections marked by the 'SEC.' abbreviation" do
    expect(Processors::SeparateSections.process(<<-DOC)).
 ‘‘SEC. 494. TAX TREATMENT OF CONTRACTS SIMILAR TO
              DERIVATIVES.
    DOC
    to eq(<<-DOC)
 ‘‘SEC. 494. TAX TREATMENT OF CONTRACTS SIMILAR TO DERIVATIVES.
    DOC
  end

  it "identifies sections without any prefix characters" do
    expect(Processors::SeparateSections.process(<<-DOC)).
 SEC. 2. MODERNIZATION OF TAX TREATMENT OF CERTAIN
             DERIVATIVES.
    DOC
    to eq(<<-DOC)
 SEC. 2. MODERNIZATION OF TAX TREATMENT OF CERTAIN DERIVATIVES.
    DOC
  end

  it "identifies sections marked by the 'PART' keyword" do
    expect(Processors::SeparateSections.process(<<-DOC)).
   ‘‘PART IV—TAX TREATMENT OF DERIVATIVES
              AND SIMILAR CONTRACTS
    DOC
    to eq(<<-DOC)
   ‘‘PART IV—TAX TREATMENT OF DERIVATIVES AND SIMILAR CONTRACTS
    DOC
  end

  it "identifies sections marked by parenthesized roman numerals" do
    expect(Processors::SeparateSections.process(<<-DOC)).
                   ‘‘(i) ordinary income or loss, and
                   ‘‘(ii) attributable to a trade or busi-
    DOC
    to eq(<<-DOC)
                   ‘‘(i) ordinary income or loss, and
                   ‘‘(ii) attributable to a trade or busi-
    DOC
  end

  it "identifies sections marked by parenthesized letters" do
    expect(Processors::SeparateSections.process(<<-DOC)).
 SECTION 1. SHORT TITLE.
     (a) SHORT T ITLE.—This Act may be cited as the
‘‘Modernization of Derivatives Tax Act of 2017’’.
     (b) MENDMENT OF   1986 C ODE.—Except as other-
wise expressly provided, whenever in this Act an amend-
ment or repeal is expressed in terms of an amendment
to, or repeal of, a section or other provision, the reference
shall be considered to be made to a section or other provi-
sion of the Internal Revenue Code of 1986.
    DOC
    to eq(<<-DOC)
 SECTION 1. SHORT TITLE.
     (a) SHORT T ITLE.—This Act may be cited as the ‘‘Modernization of Derivatives Tax Act of 2017’’.
     (b) MENDMENT OF   1986 C ODE.—Except as other- wise expressly provided, whenever in this Act an amend- ment or repeal is expressed in terms of an amendment to, or repeal of, a section or other provision, the reference shall be considered to be made to a section or other provi- sion of the Internal Revenue Code of 1986.
    DOC
  end

  it "doesn't start separating sections until it sees Section 1" do
    expect(Processors::SeparateSections.process(<<-DOC)).




115THCONGRESS
   1STSESSION      S.ll

To amend the Internal Revenue Code of 1986 to modernize the tax treatment
   of derivatives and their underlying investments, and for other purposes.


    IN THE SENATE OF THE UNITED STATES
                   llllllllll
 Mr. YDEN introduced the following bill; which was read twice and referred
           to the Committee on llllllllll



                   A BILL
To amend the Internal Revenue Code of 1986 to modernize
    the tax treatment of derivatives and their underlying
    investments, and for other purposes.

     Be it enacted by the Senate and House of Representa-
tives of the United States of America in Congress assembled,
 SECTION 1. SHORT TITLE.
     (a) SHORT T ITLE.—This Act may be cited as the
‘‘Modernization of Derivatives Tax Act of 2017’’.
    DOC
    to eq(<<-DOC)
115THCONGRESS
   1STSESSION      S.ll
To amend the Internal Revenue Code of 1986 to modernize the tax treatment
   of derivatives and their underlying investments, and for other purposes.
    IN THE SENATE OF THE UNITED STATES
                   llllllllll
 Mr. YDEN introduced the following bill; which was read twice and referred
           to the Committee on llllllllll
                   A BILL
To amend the Internal Revenue Code of 1986 to modernize
    the tax treatment of derivatives and their underlying
    investments, and for other purposes.
     Be it enacted by the Senate and House of Representa-
tives of the United States of America in Congress assembled,
 SECTION 1. SHORT TITLE.
     (a) SHORT T ITLE.—This Act may be cited as the ‘‘Modernization of Derivatives Tax Act of 2017’’.
    DOC
  end

  it "respects the line divisions of blockquotes" do
    expect(Processors::SeparateSections.process(<<-DOC)).
   ‘‘PART IV—TAX TREATMENT OF DERIVATIVES
              AND SIMILAR CONTRACTS
>     ‘‘Subpart B. Similar contracts
                ‘‘Subpart A—Derivatives
>     ‘‘Sec. 491. Rules for treatment of derivatives.
>     ‘‘Sec. 492. Investment hedging units.
>     ‘‘Sec. 493. Derivative defined.
      DOC
      to eq(<<-DOC)
   ‘‘PART IV—TAX TREATMENT OF DERIVATIVES AND SIMILAR CONTRACTS
>     ‘‘Subpart B. Similar contracts
                ‘‘Subpart A—Derivatives
>     ‘‘Sec. 491. Rules for treatment of derivatives.
>     ‘‘Sec. 492. Investment hedging units.
>     ‘‘Sec. 493. Derivative defined.
    DOC
  end
end
