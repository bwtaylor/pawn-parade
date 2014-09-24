class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :admin

  has_many :team_managers
  has_many :managed_teams, :through => :team_managers , source: :team

  has_many :guardians, :primary_key => :email, :foreign_key => :email
  has_many :players, :through => :guardians

  def after_password_reset
    confirm!
  end

end
