# -*- coding: utf-8 -*-
require 'spec_helper'

describe WikiRecord do
  before do
    #TODO: Add helpers for mock Wikipedia people
    @sam_neill = WikiRecord.new "Sam_Neill"
    def @sam_neill.fetch
      @response = 1
      parse_info_box "{{Infobox person
| image = SamNeill08TIFF.jpg
| imagesize =
| caption = Neill at the [[2008 Toronto International Film Festival]]
| birth_name = Nigel John Dermot Neill
| birth_date = {{Birth date and age|df=yes|1947|09|14}}
| birth_place =  [[Omagh]], [[Northern Ireland]], UK
| death_date =
| death_place =
| othername =
| yearsactive =1975–present
| occupation = Actor
| spouse = [[Lisa Harrow]] (unknown – c. 1989; 1 child)<br />Noriko Watanabe (September 1989 – present; 1 child)
| website =
}}
"
    end
  end
  describe "#person?" do
    it "works on Sam Neill" do
      @sam_neill.should_not == nil
      @sam_neill.person?.should == true
      debugger
      puts "asdf"
    end
  end
end
