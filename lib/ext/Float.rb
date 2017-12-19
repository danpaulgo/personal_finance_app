class Float
  def ceil2(exp = 0)
   multiplier = 10 ** exp
   ((self * multiplier).ceil).to_f/multiplier.to_f
  end
end