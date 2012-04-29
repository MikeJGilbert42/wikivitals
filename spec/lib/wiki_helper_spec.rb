describe WikiHelper do
  describe "#repair_link" do
    it "repairs the links I've encountered that have broken stuff" do
      WikiHelper::repair_link("Abraham Lincoln").should == "Abraham_Lincoln"
      WikiHelper::repair_link("Archduke_Franz_Ferdinand_Of_Austria").should == "Archduke_Franz_Ferdinand_of_Austria"
      WikiHelper::repair_link("Jack White (musician)").should == "Jack_White_(musician)"
    end
  end
end
