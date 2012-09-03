require 'conference_track_manager.rb'

describe ConferenceTrackManager do
  before do
    @manager = ConferenceTrackManager.new
    @manager.add_talks("Writing Fast Tests Against Enterprise Rails 60min\n"+
    "Overdoing it in Python 45min\n"+
    "Lua for the Masses 30min\n"+
    "Ruby Errors from Mismatched Gem Versions 45min\n"+
    "Common Ruby Errors 45min\n"+
    "Rails for Python Developers lightning\n"+
    "Communicating Over Distance 60min\n"+
    "Accounting-Driven Development 45min\n"+
    "Woah 30min\n"+
    "Sit Down and Write 30min\n"+
    "Pair Programming vs Noise 45min\n"+
    "Rails Magic 60min\n"+
    "Ruby on Rails: Why We Should Move On 60min\n"+
    "Clojure Ate Scala (on my project) 45min\n"+
    "Programming in the Boondocks of Seattle 30min\n"+
    "Ruby vs. Clojure for Back-End Development 30min\n"+
    "Ruby on Rails Legacy App Maintenance 60min\n"+
    "A World Without HackerNews 30min\n"+
    "User Interface CSS in Rails Apps 30min")
  end
  
  it 'finds the total time for all the talks' do
    @manager.total_time.should == 785
  end
  
  it 'determines the number of tracks needed' do
    @manager.tracks.count.should == 2
  end
  
  describe "conflict" do
    it "doesn't occur with lunch" do
      @manager.tracks.each do |track|
        noon = Time.new(track.talks.first.time.year, track.talks.first.time.month, track.talks.first.time.day, 12, 0)
        one = noon + 60*60
        talks_between_noon_and_one = track.talks.select do |talk|
          (talk.time >= noon && talk.time < one) || 
          (talk.time + talk.duration*60 > noon && talk.time + talk.duration*60 < one)
        end
        talks_between_noon_and_one.count.should == 1
        talks_between_noon_and_one.first.title.should == "Lunch"
        talks_between_noon_and_one.first.time.should == noon
        talks_between_noon_and_one.first.duration.should == 60
      end
    end
    
    describe "with networking event" do
      before do
        @last_talk_per_track = @manager.tracks.map do |track|
          track.talks.last
        end
      end
      
      it "has correct title and start time between 4pm and 5pm" do
        date = @last_talk_per_track.first.time
        four = Time.new(date.year, date.month, date.day, 16, 0)
        five = four + 60*60
        @last_talk_per_track.each do |networking_event|
          (networking_event.time >= four).should == true
          (networking_event.time <= five).should == true
          networking_event.title.should == "Networking Event"
        end
      end
      
      it "doesn't occur with other talks" do
        @manager.tracks.each do |track|
          networking_event_start_time = track.talks.last.time
          talks_between = track.talks.select do |talk|
            (talk.time >= networking_event_start_time) || 
            (talk.time + talk.duration*60 > networking_event_start_time)
          end
          talks_between.count.should == 1
          talks_between.first.title.should == "Networking Event"
        end
      end
    end
  end
  
  it "has no gaps or overlaps between talks" do
    @manager.tracks.each do |track|
      for i in 0..track.talks.count-2
        track.talks[i+1].time.should == track.talks[i].time + track.talks[i].duration*60
      end
    end
  end
  
  it "accurately displays the schedule as a string" do
    @manager.to_s =~ /\A((Track \d:\n)(((\d{2}:\d{2}(A|P)M)(\s|\w|[:().-])+)+(\n)?)+)+(\n)?\z/ #This is so gross
    $1.should == @manager.to_s
  end
end