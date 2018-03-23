class String

  def to_title
    lowercase_words = ["of", "the", "on", "to"]
    self.split(/_|\s/).map{ |w| lowercase_words.include?(w) ? w : w.capitalize}.join(" ")
  end

  def to_snake
    self.split(/_|\s/).map{|w| w.downcase}.join("_")
  end

  def to_boolean
    return true   if self == true   || self =~ (/(true|t|yes|y|1)$/i)
    return false  if self == false  || self.blank? || self =~ (/(false|f|no|n|0)$/i)
    raise ArgumentError.new("invalid value for Boolean: \"#{self}\"")
  end

end