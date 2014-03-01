class Guardian < ActiveRecord::Base
  attr_accessible :player_id, :email
  belongs_to :player, foreign_key: 'player_id'
  belongs_to :user, :primary_key => :email , :foreign_key => :email
end
