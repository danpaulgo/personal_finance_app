class Integer

  def to_price
    "$#{sprintf "%.2f", self}"
  end

end