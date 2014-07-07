module SectionsHelper

  def k(grade)
    if grade == 0
      'K'
    elsif  grade == 99
      'Adult'
    else
      "#{grade}"
    end
  end

end
