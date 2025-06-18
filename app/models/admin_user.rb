class AdminUser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :validatable,:registerable

  def self.ransackable_attributes(auth_object = nil)
    %w[id email created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end
  
  def self.ransackable_scopes(auth_object = nil)
    []
  end
  
  def self.search(query)
    if query.present?
      ransack(email_cont: query).result(distinct: true)
    else
      all
    end
  end
  def self.search_by_email(email)
    if email.present?
      where("email LIKE ?", "%#{email}%")
    else
      all
    end
  end
  def self.search_by_date_range(start_date, end_date)
    if start_date.present? && end_date.present?
      where(created_at: start_date..end_date)
    elsif start_date.present?
      where("created_at >= ?", start_date)
    elsif end_date.present?
      where("created_at <= ?", end_date)
    else
      all
    end
  end
end
