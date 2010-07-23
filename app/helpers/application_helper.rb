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
  
  def linked_tags(tags)
    raw(tags.collect do |tag| link_to(tag.contents, tag_path(tag)) end.join(', ') )
  end
  
  def user(obj)
    if obj.respond_to? :nickname
      obj.nickname
    elsif obj.respond_to? :user
      user(obj.user)
    else
      "(Cannot find user)"
    end
  end
end
