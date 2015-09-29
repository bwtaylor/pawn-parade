module PlayersHelper

  def un_k(grade)
    grade == 'K' ? 0 : grade.to_i
  end

  def freshen_ratings
    Player.all.each do |p|
      p.uscf if p.uscf_id.length = 8
      p.save!
    end
  end

end
