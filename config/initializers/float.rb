class Float

  def to_price
    "$#{sprintf "%.2f", self}"
  end

end