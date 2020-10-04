require "processors/congressional_record"

describe Processors::CongressionalRecord::Page do
  describe "#lines" do
    it "recognizes a line split among many divs" do
      page = Processors::CongressionalRecord::Page.new(<<-SOURCE)
<DIV style="position:absolute;top:408;left:80"><nobr><span class="ft112">The SPEAKER pro tempore laid be-</span></nobr></DIV>
<DIV style="position:absolute;top:422;left:68"><nobr><span class="ft117">fore the House the following commu-</span></nobr></DIV>
<DIV style="position:absolute;top:435;left:68"><nobr><span class="ft120">nication from the Speaker:</span></nobr></DIV>
<DIV style="position:absolute;top:451;left:193"><nobr><span class="ft123">W</span><span class="ft16">ASHINGTON</span><span class="ft15">, DC,</span></nobr></DIV>
<DIV style="position:absolute;top:463;left:229"><nobr><span class="ft125">October 1, 2020.</span></nobr></DIV>
<DIV style="position:absolute;top:475;left:78"><nobr><span class="ft15">I</span></nobr></DIV>
<DIV style="position:absolute;top:475;left:92"><nobr><span class="ft15">hereby</span></nobr></DIV>
<DIV style="position:absolute;top:475;left:139"><nobr><span class="ft15">appoint</span></nobr></DIV>
<DIV style="position:absolute;top:475;left:190"><nobr><span class="ft15">the</span></nobr></DIV>
<DIV style="position:absolute;top:475;left:217"><nobr><span class="ft15">Honorable</span></nobr></DIV>
<DIV style="position:absolute;top:475;left:283"><nobr><span class="ft126">H</span><span class="ft16">ENRY</span></nobr></DIV>
<DIV style="position:absolute;top:487;left:68"><nobr><span class="ft134">C</span><span class="ft16">UELLAR </span><span class="ft15">to act as Speaker pro tempore on</span></nobr></DIV>
<DIV style="position:absolute;top:499;left:68"><nobr><span class="ft135">this day.</span></nobr></DIV>
      SOURCE

      expect(page.lines).to eq(<<-LINES.lines)
The SPEAKER pro tempore laid be-
fore the House the following commu-
nication from the Speaker:
WASHINGTON, DC,
October 1, 2020.
I hereby appoint the Honorable HENRY
CUELLAR to act as Speaker pro tempore on
this day.
      LINES
    end
  end
end
