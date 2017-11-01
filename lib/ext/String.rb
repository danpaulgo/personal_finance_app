class String

  def to_title
    self.split(/_|\s/).map{ |w| (w != "of" && w != "the") ? w.capitalize : w}.join(" ")
  end

end