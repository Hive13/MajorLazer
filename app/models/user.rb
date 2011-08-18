class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :username

  has_many :time_balances
  has_many :roles

  def has_role? r
    roles.each do |user_role|
        return true if user_role.name == r
    end
    return false
  end

  def balance
    time_balances.to_a.sum(&:minutes)
  end
end
