module PlayersHelper

  def un_k(grade)
    grade == 'K' ? 0 : grade.to_i
  end

  def freshen_ratings
    Player.all.each do |p|
      p.uscf
      p.save!
    end
  end

end
