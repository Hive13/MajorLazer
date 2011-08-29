class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :username

  has_many :time_balances
  has_many :free_minutes
  has_many :roles
  belongs_to :membership_level

  def name
    return username if username
    return email
  end

  def has_role? r
    roles.each do |user_role|
        return true if user_role.name == r
    end
    return false
  end

  def balance
    time_balances.to_a.sum(&:minutes)
  end

  def free_balance
    free_minutes.where('expire_on >= NOW()').to_a.sum(&:minutes)
  end

  def last_free_minute
    free_minutes.where('expire_on >= NOW()').limit(1).last
  end

  def full_balance
    balance + free_balance
  end

  def member_level
    if member then
      return membership_level.name
    end
    return "Non-Member"
  end

end
