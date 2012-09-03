class Talk
  def initialize(string)
    tokenized = string.split(' ')
    @title = tokenized[0..-2].join(' ')
    @duration = tokenized.last
    if @duration =~ /lightning/
      @duration = 5
    else
      @duration = @duration.gsub('min', '').to_i
    end
    
    if @title =~ /\d+/
      raise "Cannot have numbers within title."
    end
  end
  
  def duration
    @duration
  end
  
  def duration=(min)
    @duration = min
  end
  
  def time
    @time
  end
  
  def time=(given_time)
    @time = given_time
  end
  
  def title
    @title
  end
  
  def to_s
    if @title == "Lunch" || @title == "Networking Event"
      duration_string = ""
    elsif @duration == 5
      duration_string = " lightning"
    else
      duration_string = " #{@duration}min"
    end
    
    @time.strftime("%I:%M%p") + ' '  + @title + duration_string
  end
end