class String

  def snake_to_title
    self.split("_").map{ |w| (w != "of" && w != "the") ? w.capitalize : w}.join(" ")
  end

end