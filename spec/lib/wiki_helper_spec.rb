include WikiHelper

describe WikiHelper do
  describe "#repair_link" do
    it "repairs the links I've encountered that have broken stuff" do
      repair_link("Abraham Lincoln").should == "Abraham_Lincoln"
      repair_link("Archduke_Franz_Ferdinand_Of_Austria").should == "Archduke_Franz_Ferdinand_of_Austria"
      repair_link("Jack White (musician)").should == "Jack_White_(musician)"
      repair_link("Catherine Zeta-Jones").should == "Catherine_Zeta-Jones"
      repair_link("John DeLorean").should == "John_DeLorean"
    end
  end
end
