module ApplicationHelper
  
  def dateandtime(date, format=false)
    format ||= '%b %d %Y, %I:%M %p'
    if date.respond_to? :strftime
      date.strftime(format)
    elsif date.respond_to? :created_at
      dateandtime(date.created_at, format)
    else
      "(Date cannot be parsed)"
    end
  end
  
  def dateonly(date)
    dateandtime(date, '%b %d %Y')
  end
  
end
