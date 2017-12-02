class String

  def to_title
    lowercase_words = ["of", "the", "on"]
    self.split(/_|\s/).map{ |w| lowercase_words.include?(w) ? w : w.capitalize}.join(" ")
  end

  def to_snake
    self.split(/_|\s/).map{|w| w.downcase}.join("_")
  end

end