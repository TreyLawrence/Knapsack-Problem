require 'conference_track_manager/talk.rb'

describe Talk do
  describe 'parses an input string' do
    it 'separates the talk title from the talk time with "%dmin"' do
      talk = Talk.new("Writing Fast Tests Against Enterprise Rails 60min")
      talk.title.should == "Writing Fast Tests Against Enterprise Rails"
      talk.duration.should == 60
    end
    
    it 'separates the talk title from the talk time with "lightning"' do
      talk = Talk.new("Rails for Python Developers lightning")
      talk.title.should == "Rails for Python Developers"
      talk.duration.should == 5
    end
  end
  
  it "won't accept titles with numbers" do
    talk = Talk.new("Rails 123 70min") rescue nil
    talk.nil?.should == true
  end
  
  it "prints a talk correctly" do
    talk = Talk.new("Writing Fast Tests Against Enterprise Rails 60min")
    test_time = Time.now
    talk.time = test_time
    talk.to_s.should == "#{test_time.strftime("%I:%M%p")} Writing Fast Tests Against Enterprise Rails 60min"
    
    talk = Talk.new("Lunch 60min")
    test_time = Time.now
    talk.time = test_time
    talk.to_s.should == "#{test_time.strftime("%I:%M%p")} Lunch"
    
    talk = Talk.new("Networking Event 60min")
    test_time = Time.now
    talk.time = test_time
    talk.to_s.should == "#{test_time.strftime("%I:%M%p")} Networking Event"
  end
end