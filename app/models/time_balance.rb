class TimeBalance < ActiveRecord::Base
 belongs_to :user
 paginates_per 15

end
