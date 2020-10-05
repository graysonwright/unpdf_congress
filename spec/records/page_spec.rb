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

    it "pulls a grid as a single line" do
      page = Processors::CongressionalRecord::Page.new(<<-SOURCE)
<DIV style="position:absolute;top:577;left:599"><nobr><span class="ft673">as follows:</span></nobr></DIV>
<DIV style="position:absolute;top:623;left:332"><nobr><span class="ft677">``If the calendar year is:</span></nobr></DIV>
<DIV style="position:absolute;top:602;left:740"><nobr><span class="ft678">The ap-</span></nobr></DIV>
<DIV style="position:absolute;top:612;left:740"><nobr><span class="ft3">plicable</span></nobr></DIV>
<DIV style="position:absolute;top:623;left:737"><nobr><span class="ft3">minimum</span></nobr></DIV>
<DIV style="position:absolute;top:633;left:739"><nobr><span class="ft3">percent-</span></nobr></DIV>
<DIV style="position:absolute;top:644;left:744"><nobr><span class="ft679">age is:</span></nobr></DIV>
<DIV style="position:absolute;top:602;left:804"><nobr><span class="ft680">The ap-</span></nobr></DIV>
<DIV style="position:absolute;top:612;left:804"><nobr><span class="ft3">plicable</span></nobr></DIV>
<DIV style="position:absolute;top:623;left:799"><nobr><span class="ft3">maximum</span></nobr></DIV>
<DIV style="position:absolute;top:633;left:803"><nobr><span class="ft3">percent-</span></nobr></DIV>
<DIV style="position:absolute;top:644;left:807"><nobr><span class="ft681">age is:</span></nobr></DIV>
<DIV style="position:absolute;top:667;left:68"><nobr><span class="ft694">Any year in the period starting in 2012 and ending in 2019 ....................................................................................................</span></nobr></DIV>
<DIV style="position:absolute;top:667;left:766"><nobr><span class="ft3">90%</span></nobr></DIV>
<DIV style="position:absolute;top:667;left:813"><nobr><span class="ft3">110%</span></nobr></DIV>
<DIV style="position:absolute;top:679;left:68"><nobr><span class="ft694">Any year in the period starting in 2020 and ending in 2025 ....................................................................................................</span></nobr></DIV>
<DIV style="position:absolute;top:679;left:766"><nobr><span class="ft3">95%</span></nobr></DIV>
<DIV style="position:absolute;top:679;left:813"><nobr><span class="ft3">105%</span></nobr></DIV>
<DIV style="position:absolute;top:691;left:68"><nobr><span class="ft696">2026 ....................................................................................................................................................................................</span></nobr></DIV>
<DIV style="position:absolute;top:691;left:766"><nobr><span class="ft3">90%</span></nobr></DIV>
<DIV style="position:absolute;top:691;left:813"><nobr><span class="ft3">110%</span></nobr></DIV>
<DIV style="position:absolute;top:703;left:68"><nobr><span class="ft696">2027 ....................................................................................................................................................................................</span></nobr></DIV>
<DIV style="position:absolute;top:703;left:766"><nobr><span class="ft3">85%</span></nobr></DIV>
<DIV style="position:absolute;top:703;left:813"><nobr><span class="ft3">115%</span></nobr></DIV>
<DIV style="position:absolute;top:715;left:68"><nobr><span class="ft696">2028 ....................................................................................................................................................................................</span></nobr></DIV>
<DIV style="position:absolute;top:715;left:766"><nobr><span class="ft3">80%</span></nobr></DIV>
<DIV style="position:absolute;top:715;left:813"><nobr><span class="ft3">120%</span></nobr></DIV>
<DIV style="position:absolute;top:727;left:68"><nobr><span class="ft696">2029 ....................................................................................................................................................................................</span></nobr></DIV>
<DIV style="position:absolute;top:727;left:766"><nobr><span class="ft3">75%</span></nobr></DIV>
<DIV style="position:absolute;top:727;left:813"><nobr><span class="ft3">125%</span></nobr></DIV>
<DIV style="position:absolute;top:739;left:68"><nobr><span class="ft699">After 2029 ...........................................................................................................................................................................</span></nobr></DIV>
<DIV style="position:absolute;top:739;left:766"><nobr><span class="ft3">70%</span></nobr></DIV>
<DIV style="position:absolute;top:739;left:810"><nobr><span class="ft3">130%.''.</span></nobr></DIV>
<DIV style="position:absolute;top:772;left:78"><nobr><span class="ft707">(2) F</span><span class="ft4">LOOR ON 25</span><span class="ft3">-</span><span class="ft4">YEAR AVERAGES</span><span class="ft3">.--Subclause</span></nobr></DIV>
<DIV style="position:absolute;top:784;left:68"><nobr><span class="ft714">(I) of section 430(h)(2)(C)(iv) of such Code is</span></nobr></DIV>
<DIV style="position:absolute;top:796;left:68"><nobr><span class="ft721">amended by adding at the end the following:</span></nobr></DIV>
      SOURCE

      expect(page.lines).to eq([
        "as follows:\n",
        { region: :grid,
          dimensions: [3, 7],
          headers: [
            "If the calendar year is:",
            "The ap-\nplicable\nminimum\npercent\nage is:",
            "The ap-\nplicable\nmaximum\npercent\nage is:",
          ],
          code: [
            ["Any year in the period starting in 2012 and ending in 2019", "90%", "110%"],
            ["Any year in the period starting in 2020 and ending in 2025", "95%", "105%",],
            ["2026", "90%", "110%"],
            ["2027", "85%", "115%"],
            ["2028", "80%", "120%"],
            ["2029", "75%", "125%"],
            ["After 2029", "70%", "130%"],
          ],
        },
      ])
    end

    it "second case; pulls a grid as a single line" do
      page = Processors::CongressionalRecord::Page.new(<<-SOURCE)
<DIV style="position:absolute;top:142;left:78"><nobr><span class="ft2">Attachment.</span></nobr></DIV>
<DIV style="position:absolute;top:165;left:75"><nobr><span class="ft45">AGGREGATE AMOUNT EXPENDED ON OUTSIDE COUNSEL</span></nobr></DIV>
<DIV style="position:absolute;top:179;left:124"><nobr><span class="ft49">OR OTHER EXPERTS--H. RES. 6</span></nobr></DIV>
<DIV style="position:absolute;top:204;left:68"><nobr><span class="ft53">January 1­March 31, 2019 .............................................</span></nobr></DIV>
<DIV style="position:absolute;top:204;left:306"><nobr><span class="ft6">0.00</span></nobr></DIV>
<DIV style="position:absolute;top:214;left:68"><nobr><span class="ft57">April 1­June 30, 2019 .....................................................</span></nobr></DIV>
<DIV style="position:absolute;top:214;left:306"><nobr><span class="ft6">0.00</span></nobr></DIV>
<DIV style="position:absolute;top:225;left:68"><nobr><span class="ft61">July 1­September 30, 2019 .............................................</span></nobr></DIV>
<DIV style="position:absolute;top:225;left:306"><nobr><span class="ft6">0.00</span></nobr></DIV>
<DIV style="position:absolute;top:235;left:68"><nobr><span class="ft65">October 1­December 31, 2019 ........................................</span></nobr></DIV>
<DIV style="position:absolute;top:235;left:306"><nobr><span class="ft6">0.00</span></nobr></DIV>
<DIV style="position:absolute;top:246;left:68"><nobr><span class="ft53">January 1­March 31, 2020 .............................................</span></nobr></DIV>
<DIV style="position:absolute;top:246;left:306"><nobr><span class="ft6">0.00</span></nobr></DIV>
<DIV style="position:absolute;top:256;left:68"><nobr><span class="ft57">April 1­June 30, 2020 .....................................................</span></nobr></DIV>
<DIV style="position:absolute;top:256;left:306"><nobr><span class="ft6">0.00</span></nobr></DIV>
<DIV style="position:absolute;top:267;left:68"><nobr><span class="ft61">July 1­September 30, 2020 .............................................</span></nobr></DIV>
<DIV style="position:absolute;top:267;left:306"><nobr><span class="ft6">0.00</span></nobr></DIV>
<DIV style="position:absolute;top:287;left:86"><nobr><span class="ft66">Total ........................................................................</span></nobr></DIV>
<DIV style="position:absolute;top:287;left:306"><nobr><span class="ft6">0.00</span></nobr></DIV>
<DIV style="position:absolute;top:308;left:152"><nobr><span class="ft2">f</span></nobr></DIV>
<DIV style="position:absolute;top:329;left:106"><nobr><span class="ft68">ENROLLED BILL SIGNED</span></nobr></DIV>
      SOURCE

      expect(page.lines).to eq([
        "Attachment.\n",
        { region: :grid,
          dimensions: [2, 8],
          headers: nil,
          code: [
            ["January 1­March 31, 2019", "0.00"],
            ["April 1­June 30, 2019", "0.00"],
            ["July 1­September 30, 2019", "0.00"],
            ["October 1­December 31, 2019", "0.00"],
            ["January 1­March 31, 2020", "0.00"],
            ["April 1­June 30, 2020", "0.00"],
            ["July 1­September 30, 2020", "0.00"],
            ["October 1­December 31, 2020", "0.00"],
            ["Total", "0.00"],
          ],
        },
        "f\n",
        "ENROLLED BILL SIGNED\n",
      ])
    end

    it "third case; pulls a grid as a single line" do
      page = Processors::CongressionalRecord::Page.new(<<-SOURCE)
<DIV style="position:absolute;top:196;left:101"><nobr><span class="ft82">The first table gives a comprehensive re´sume´ of all legislative business transacted by the Senate and House.</span></nobr></DIV>
<DIV style="position:absolute;top:214;left:100"><nobr><span class="ft98">The second table accounts for all nominations submitted to the Senate by the President for Senate confirmation.</span></nobr></DIV>
<DIV style="position:absolute;top:251;left:128"><nobr><span class="ft101">DATA ON LEGISLATIVE ACTIVITY</span></nobr></DIV>
<DIV style="position:absolute;top:275;left:138"><nobr><span class="ft106">January 3 through September 30, 2020</span></nobr></DIV>
<DIV style="position:absolute;top:297;left:299"><nobr><span class="ft8">Senate</span></nobr></DIV>
<DIV style="position:absolute;top:297;left:374"><nobr><span class="ft8">House</span></nobr></DIV>
<DIV style="position:absolute;top:297;left:419"><nobr><span class="ft8">Total</span></nobr></DIV>
<DIV style="position:absolute;top:314;left:68"><nobr><span class="ft109">Days in session ....................................</span></nobr></DIV>
<DIV style="position:absolute;top:314;left:311"><nobr><span class="ft3">140</span></nobr></DIV>
<DIV style="position:absolute;top:314;left:384"><nobr><span class="ft3">123</span></nobr></DIV>
<DIV style="position:absolute;top:314;left:437"><nobr><span class="ft110">. .</span></nobr></DIV>
<DIV style="position:absolute;top:331;left:68"><nobr><span class="ft113">Time in session ...................................</span></nobr></DIV>
<DIV style="position:absolute;top:331;left:269"><nobr><span class="ft115">717 hrs., 33</span></nobr></DIV>
<DIV style="position:absolute;top:326;left:326"><nobr><span class="ft119"> 432 hrs., 38</span></nobr></DIV>
<DIV style="position:absolute;top:331;left:437"><nobr><span class="ft3">..</span></nobr></DIV>
<DIV style="position:absolute;top:347;left:68"><nobr><span class="ft120">Congressional Record:</span></nobr></DIV>
<DIV style="position:absolute;top:363;left:92"><nobr><span class="ft123">Pages of proceedings ...................</span></nobr></DIV>
<DIV style="position:absolute;top:363;left:302"><nobr><span class="ft3">6,007</span></nobr></DIV>
<DIV style="position:absolute;top:363;left:375"><nobr><span class="ft3">5,107</span></nobr></DIV>
<DIV style="position:absolute;top:363;left:437"><nobr><span class="ft110">. .</span></nobr></DIV>
<DIV style="position:absolute;top:379;left:92"><nobr><span class="ft126">Extensions of Remarks ................</span></nobr></DIV>
<DIV style="position:absolute;top:379;left:320"><nobr><span class="ft127">. .</span></nobr></DIV>
<DIV style="position:absolute;top:379;left:384"><nobr><span class="ft3">907</span></nobr></DIV>
<DIV style="position:absolute;top:379;left:437"><nobr><span class="ft110">. .</span></nobr></DIV>
<DIV style="position:absolute;top:395;left:68"><nobr><span class="ft132">Public bills enacted into law ...............</span></nobr></DIV>
<DIV style="position:absolute;top:395;left:317"><nobr><span class="ft3">25</span></nobr></DIV>
<DIV style="position:absolute;top:395;left:390"><nobr><span class="ft3">28</span></nobr></DIV>
<DIV style="position:absolute;top:395;left:434"><nobr><span class="ft3">53</span></nobr></DIV>
<DIV style="position:absolute;top:412;left:68"><nobr><span class="ft137">Private bills enacted into law ..............</span></nobr></DIV>
<DIV style="position:absolute;top:412;left:320"><nobr><span class="ft110">. .</span></nobr></DIV>
<DIV style="position:absolute;top:412;left:394"><nobr><span class="ft110">. .</span></nobr></DIV>
<DIV style="position:absolute;top:412;left:437"><nobr><span class="ft110">. .</span></nobr></DIV>
<DIV style="position:absolute;top:428;left:68"><nobr><span class="ft140">Bills in conference ...............................</span></nobr></DIV>
<DIV style="position:absolute;top:428;left:320"><nobr><span class="ft110">. .</span></nobr></DIV>
<DIV style="position:absolute;top:428;left:396"><nobr><span class="ft3">1</span></nobr></DIV>
<DIV style="position:absolute;top:428;left:437"><nobr><span class="ft110">. .</span></nobr></DIV>
<DIV style="position:absolute;top:444;left:68"><nobr><span class="ft143">Measures passed, total .........................</span></nobr></DIV>
<DIV style="position:absolute;top:444;left:311"><nobr><span class="ft3">285</span></nobr></DIV>
<DIV style="position:absolute;top:444;left:384"><nobr><span class="ft3">358</span></nobr></DIV>
<DIV style="position:absolute;top:444;left:428"><nobr><span class="ft3">643</span></nobr></DIV>
<DIV style="position:absolute;top:460;left:92"><nobr><span class="ft145">Senate bills ..................................</span></nobr></DIV>
<DIV style="position:absolute;top:460;left:317"><nobr><span class="ft3">86</span></nobr></DIV>
<DIV style="position:absolute;top:460;left:390"><nobr><span class="ft3">39</span></nobr></DIV>
<DIV style="position:absolute;top:460;left:437"><nobr><span class="ft110">. .</span></nobr></DIV>
<DIV style="position:absolute;top:476;left:92"><nobr><span class="ft147">House bills ..................................</span></nobr></DIV>
<DIV style="position:absolute;top:476;left:317"><nobr><span class="ft3">36</span></nobr></DIV>
<DIV style="position:absolute;top:476;left:384"><nobr><span class="ft3">238</span></nobr></DIV>
<DIV style="position:absolute;top:476;left:437"><nobr><span class="ft110">. .</span></nobr></DIV>
<DIV style="position:absolute;top:493;left:92"><nobr><span class="ft150">Senate joint resolutions ...............</span></nobr></DIV>
<DIV style="position:absolute;top:493;left:323"><nobr><span class="ft3">5</span></nobr></DIV>
<DIV style="position:absolute;top:493;left:396"><nobr><span class="ft3">4</span></nobr></DIV>
<DIV style="position:absolute;top:493;left:437"><nobr><span class="ft110">. .</span></nobr></DIV>
<DIV style="position:absolute;top:509;left:92"><nobr><span class="ft153">House joint resolutions ...............</span></nobr></DIV>
<DIV style="position:absolute;top:509;left:323"><nobr><span class="ft3">4</span></nobr></DIV>
<DIV style="position:absolute;top:509;left:396"><nobr><span class="ft3">6</span></nobr></DIV>
<DIV style="position:absolute;top:509;left:437"><nobr><span class="ft110">. .</span></nobr></DIV>
<DIV style="position:absolute;top:525;left:92"><nobr><span class="ft156">Senate concurrent resolutions ......</span></nobr></DIV>
<DIV style="position:absolute;top:525;left:323"><nobr><span class="ft3">4</span></nobr></DIV>
<DIV style="position:absolute;top:525;left:396"><nobr><span class="ft3">2</span></nobr></DIV>
<DIV style="position:absolute;top:525;left:437"><nobr><span class="ft127">. .</span></nobr></DIV>
<DIV style="position:absolute;top:541;left:92"><nobr><span class="ft159">House concurrent resolutions ......</span></nobr></DIV>
<DIV style="position:absolute;top:541;left:323"><nobr><span class="ft3">6</span></nobr></DIV>
<DIV style="position:absolute;top:541;left:396"><nobr><span class="ft3">8</span></nobr></DIV>
<DIV style="position:absolute;top:541;left:437"><nobr><span class="ft127">. .</span></nobr></DIV>
<DIV style="position:absolute;top:557;left:92"><nobr><span class="ft161">Simple resolutions .......................</span></nobr></DIV>
<DIV style="position:absolute;top:557;left:311"><nobr><span class="ft3">144</span></nobr></DIV>
<DIV style="position:absolute;top:557;left:390"><nobr><span class="ft3">61</span></nobr></DIV>
<DIV style="position:absolute;top:557;left:437"><nobr><span class="ft110">. .</span></nobr></DIV>
<DIV style="position:absolute;top:574;left:68"><nobr><span class="ft164">Measures reported, total ......................</span></nobr></DIV>
<DIV style="position:absolute;top:574;left:305"><nobr><span class="ft3">*128</span></nobr></DIV>
<DIV style="position:absolute;top:574;left:384"><nobr><span class="ft3">183</span></nobr></DIV>
<DIV style="position:absolute;top:574;left:428"><nobr><span class="ft3">311</span></nobr></DIV>
<DIV style="position:absolute;top:590;left:92"><nobr><span class="ft145">Senate bills ..................................</span></nobr></DIV>
<DIV style="position:absolute;top:590;left:317"><nobr><span class="ft3">98</span></nobr></DIV>
<DIV style="position:absolute;top:590;left:396"><nobr><span class="ft3">2</span></nobr></DIV>
<DIV style="position:absolute;top:590;left:437"><nobr><span class="ft110">. .</span></nobr></DIV>
<DIV style="position:absolute;top:606;left:92"><nobr><span class="ft147">House bills ..................................</span></nobr></DIV>
<DIV style="position:absolute;top:606;left:317"><nobr><span class="ft3">19</span></nobr></DIV>
<DIV style="position:absolute;top:606;left:384"><nobr><span class="ft3">155</span></nobr></DIV>
<DIV style="position:absolute;top:606;left:437"><nobr><span class="ft110">. .</span></nobr></DIV>
<DIV style="position:absolute;top:622;left:92"><nobr><span class="ft150">Senate joint resolutions ...............</span></nobr></DIV>
<DIV style="position:absolute;top:622;left:320"><nobr><span class="ft127">. .</span></nobr></DIV>
<DIV style="position:absolute;top:622;left:394"><nobr><span class="ft110">. .</span></nobr></DIV>
<DIV style="position:absolute;top:622;left:437"><nobr><span class="ft110">. .</span></nobr></DIV>
<DIV style="position:absolute;top:638;left:92"><nobr><span class="ft153">House joint resolutions ...............</span></nobr></DIV>
<DIV style="position:absolute;top:638;left:320"><nobr><span class="ft110">. .</span></nobr></DIV>
<DIV style="position:absolute;top:638;left:396"><nobr><span class="ft3">1</span></nobr></DIV>
<DIV style="position:absolute;top:638;left:437"><nobr><span class="ft110">. .</span></nobr></DIV>
<DIV style="position:absolute;top:655;left:92"><nobr><span class="ft156">Senate concurrent resolutions ......</span></nobr></DIV>
<DIV style="position:absolute;top:655;left:320"><nobr><span class="ft110">. .</span></nobr></DIV>
<DIV style="position:absolute;top:655;left:394"><nobr><span class="ft127">. .</span></nobr></DIV>
<DIV style="position:absolute;top:655;left:437"><nobr><span class="ft127">. .</span></nobr></DIV>
<DIV style="position:absolute;top:671;left:92"><nobr><span class="ft159">House concurrent resolutions ......</span></nobr></DIV>
<DIV style="position:absolute;top:671;left:320"><nobr><span class="ft110">. .</span></nobr></DIV>
<DIV style="position:absolute;top:671;left:396"><nobr><span class="ft3">2</span></nobr></DIV>
<DIV style="position:absolute;top:671;left:437"><nobr><span class="ft127">. .</span></nobr></DIV>
<DIV style="position:absolute;top:687;left:92"><nobr><span class="ft161">Simple resolutions .......................</span></nobr></DIV>
<DIV style="position:absolute;top:687;left:317"><nobr><span class="ft3">11</span></nobr></DIV>
<DIV style="position:absolute;top:687;left:390"><nobr><span class="ft3">23</span></nobr></DIV>
<DIV style="position:absolute;top:687;left:437"><nobr><span class="ft110">. .</span></nobr></DIV>
<DIV style="position:absolute;top:703;left:68"><nobr><span class="ft166">Special reports .....................................</span></nobr></DIV>
<DIV style="position:absolute;top:703;left:323"><nobr><span class="ft3">3</span></nobr></DIV>
<DIV style="position:absolute;top:703;left:396"><nobr><span class="ft3">8</span></nobr></DIV>
<DIV style="position:absolute;top:703;left:437"><nobr><span class="ft110">. .</span></nobr></DIV>
<DIV style="position:absolute;top:719;left:68"><nobr><span class="ft168">Conference reports ...............................</span></nobr></DIV>
<DIV style="position:absolute;top:719;left:320"><nobr><span class="ft127">. .</span></nobr></DIV>
<DIV style="position:absolute;top:719;left:394"><nobr><span class="ft110">. .</span></nobr></DIV>
<DIV style="position:absolute;top:719;left:437"><nobr><span class="ft110">. .</span></nobr></DIV>
<DIV style="position:absolute;top:736;left:68"><nobr><span class="ft172">Measures pending on calendar .............</span></nobr></DIV>
<DIV style="position:absolute;top:736;left:311"><nobr><span class="ft3">371</span></nobr></DIV>
<DIV style="position:absolute;top:736;left:390"><nobr><span class="ft3">78</span></nobr></DIV>
<DIV style="position:absolute;top:736;left:437"><nobr><span class="ft110">. .</span></nobr></DIV>
<DIV style="position:absolute;top:752;left:68"><nobr><span class="ft137">Measures introduced, total ..................</span></nobr></DIV>
<DIV style="position:absolute;top:752;left:302"><nobr><span class="ft3">1,938</span></nobr></DIV>
<DIV style="position:absolute;top:752;left:375"><nobr><span class="ft3">3,374</span></nobr></DIV>
<DIV style="position:absolute;top:752;left:419"><nobr><span class="ft3">5,312</span></nobr></DIV>
<DIV style="position:absolute;top:768;left:92"><nobr><span class="ft175">Bills .............................................</span></nobr></DIV>
<DIV style="position:absolute;top:768;left:302"><nobr><span class="ft3">1,629</span></nobr></DIV>
<DIV style="position:absolute;top:768;left:375"><nobr><span class="ft3">2,933</span></nobr></DIV>
<DIV style="position:absolute;top:768;left:437"><nobr><span class="ft127">. .</span></nobr></DIV>
<DIV style="position:absolute;top:784;left:92"><nobr><span class="ft177">Joint resolutions ..........................</span></nobr></DIV>
<DIV style="position:absolute;top:784;left:317"><nobr><span class="ft3">13</span></nobr></DIV>
<DIV style="position:absolute;top:784;left:390"><nobr><span class="ft3">16</span></nobr></DIV>
<DIV style="position:absolute;top:784;left:437"><nobr><span class="ft110">. .</span></nobr></DIV>
<DIV style="position:absolute;top:800;left:92"><nobr><span class="ft153">Concurrent resolutions ................</span></nobr></DIV>
<DIV style="position:absolute;top:800;left:317"><nobr><span class="ft3">17</span></nobr></DIV>
<DIV style="position:absolute;top:800;left:390"><nobr><span class="ft3">37</span></nobr></DIV>
<DIV style="position:absolute;top:800;left:437"><nobr><span class="ft110">. .</span></nobr></DIV>
<DIV style="position:absolute;top:817;left:92"><nobr><span class="ft161">Simple resolutions .......................</span></nobr></DIV>
<DIV style="position:absolute;top:817;left:311"><nobr><span class="ft3">279</span></nobr></DIV>
<DIV style="position:absolute;top:817;left:384"><nobr><span class="ft3">388</span></nobr></DIV>
<DIV style="position:absolute;top:817;left:437"><nobr><span class="ft110">. .</span></nobr></DIV>
<DIV style="position:absolute;top:833;left:68"><nobr><span class="ft180">Quorum calls .......................................</span></nobr></DIV>
<DIV style="position:absolute;top:833;left:323"><nobr><span class="ft3">1</span></nobr></DIV>
<DIV style="position:absolute;top:833;left:396"><nobr><span class="ft3">1</span></nobr></DIV>
<DIV style="position:absolute;top:833;left:437"><nobr><span class="ft110">. .</span></nobr></DIV>
<DIV style="position:absolute;top:849;left:68"><nobr><span class="ft182">Yea-and-nay votes ...............................</span></nobr></DIV>
<DIV style="position:absolute;top:849;left:311"><nobr><span class="ft3">199</span></nobr></DIV>
<DIV style="position:absolute;top:849;left:384"><nobr><span class="ft3">178</span></nobr></DIV>
<DIV style="position:absolute;top:849;left:437"><nobr><span class="ft110">. .</span></nobr></DIV>
<DIV style="position:absolute;top:865;left:68"><nobr><span class="ft184">Recorded votes ....................................</span></nobr></DIV>
<DIV style="position:absolute;top:865;left:320"><nobr><span class="ft110">. .</span></nobr></DIV>
<DIV style="position:absolute;top:865;left:390"><nobr><span class="ft3">34</span></nobr></DIV>
<DIV style="position:absolute;top:865;left:437"><nobr><span class="ft110">. .</span></nobr></DIV>
<DIV style="position:absolute;top:881;left:68"><nobr><span class="ft186">Bills vetoed .........................................</span></nobr></DIV>
<DIV style="position:absolute;top:881;left:323"><nobr><span class="ft3">1</span></nobr></DIV>
<DIV style="position:absolute;top:881;left:396"><nobr><span class="ft3">1</span></nobr></DIV>
<DIV style="position:absolute;top:881;left:437"><nobr><span class="ft110">. .</span></nobr></DIV>
<DIV style="position:absolute;top:898;left:68"><nobr><span class="ft188">Vetoes overridden ................................</span></nobr></DIV>
<DIV style="position:absolute;top:898;left:320"><nobr><span class="ft110">. .</span></nobr></DIV>
<DIV style="position:absolute;top:898;left:394"><nobr><span class="ft110">. .</span></nobr></DIV>
<DIV style="position:absolute;top:898;left:437"><nobr><span class="ft110">. .</span></nobr></DIV>
<DIV style="position:absolute;top:251;left:496"><nobr><span class="ft191">DISPOSITION OF EXECUTIVE NOMINATIONS</span></nobr></DIV>
<DIV style="position:absolute;top:275;left:543"><nobr><span class="ft196">January 3 through September 30, 2020</span></nobr></DIV>

      expect(page.lines).to eq([
        "Attachment.\n",
        { region: :grid,
          dimensions: [1, 1],
          headers: nil,
          code: [
            []
          ],
        },
        "f\n",
        "ENROLLED BILL SIGNED\n",
      ])
  end
end
