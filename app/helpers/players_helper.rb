module PlayersHelper

  # THIS IS A REALLY BAD HACK. IT NEEDS TO WORK FOR ONE DAY, THEN DIE.

  def problem(player_id)
    {
        14 =>  'YEP IT WORKS',
        608 => 'Bogus USCF ID: 11111111',
        609 => 'Bogus USCF ID: 11111111',
        627 => 'Bogus Address',
        751 => 'Bogus USCF ID: 11111111',
        752 => 'Bogus USCF ID: 11111111',
        774 => 'Bogus USCF ID: 11111111',
        943 => 'Bogus USCF ID: 11111111',
        99999 => ''
    }[player_id]
  end
end
