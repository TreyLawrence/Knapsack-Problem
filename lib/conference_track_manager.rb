class ConferenceTrackManager
  class Track
    HOURS = 60
    def initialize(date)
      @date = date
    end
    
    def talks=(talks_to_divvy_out)
      @total_time = talks_to_divvy_out.map(&:duration).inject {|sum,duration| sum += duration}
      raise "Not enough time given" if @total_time < 6*HOURS
      raise "Too much time given" if @total_time > 7*HOURS
      
      @morning_session = first_subset(talks_to_divvy_out,3*HOURS)
      @morning_session.first.time = Time.new(@date.year, @date.month, @date.day, 9, 0)
      for i in 1..@morning_session.length-1
        @morning_session[i].time = @morning_session[i-1].time + @morning_session[i-1].duration*60
      end
      
      @lunch = Talk.new("Lunch 60min")
      @lunch.time = Time.new(@date.year, @date.month, @date.day, 12, 0)
      
      @afternoon_session = talks_to_divvy_out.select {|talk| !@morning_session.include?(talk) }
      @afternoon_session.first.time = Time.new(@date.year, @date.month, @date.day, 13, 0)
      for i in 1..@afternoon_session.length-1
        @afternoon_session[i].time = @afternoon_session[i-1].time + @afternoon_session[i-1].duration*60
      end
      
      @networking_event = Talk.new("Networking Event 60min")
      @networking_event.time = @afternoon_session.last.time + @afternoon_session.last.duration*60
    end
    
    def talks
      @morning_session + [@lunch] + @afternoon_session + [@networking_event]
    end
    
    private
      def first_subset(talk_array, minutes)
        for combination_size in 1..talk_array.size
          talk_array.combination(combination_size).each do |combination|
            if combination.map(&:duration).inject {|sum, duration| sum += duration} == minutes
              return combination
            end
          end
        end
        nil
      end      
  end
  
  def add_talks(string_of_talks)
    talks = string_of_talks.split("\n").map do |talk_string|
      Talk.new(talk_string)
    end
    
    @total_time = talks.map(&:duration).inject {|sum,duration| sum += duration}
    talks.sort! {|t1, t2| t2.duration <=> t1.duration }
    @tracks = []
    divvy_up_talks = []
    
    (@total_time/(6*60)).times do
      @tracks << Track.new(Time.now)
      divvy_up_talks << []
    end
    
    talks.each_with_index {|talk,i| divvy_up_talks[i % divvy_up_talks.length] << talk}
    
    divvy_up_talks.each_with_index {|talks_to_add,i| @tracks[i].talks=talks_to_add}
  end
  
  def total_time
    @total_time
  end
  
  def leftovers
    @leftovers
  end
  
  def tracks
    @tracks
  end
  
  def to_s
    @tracks.each_with_index.map do |track, index|
      "Track #{index+1}:\n" +
      track.talks.map {|talk| talk.to_s}.join("\n")
    end.join("\n\n")
  end
end