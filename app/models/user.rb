# encoding: utf-8
# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  approved               :boolean          default(FALSE), not null
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable

  has_one :expert, dependent: :destroy
  has_one :entreprise, dependent: :destroy

  def self.not_validate
    where(approved: false).includes(:expert)
  end

  def to_s
    if expert
      "#{expert.first_name} #{expert.last_name} (expert)"
    elsif entreprise
      "#{entreprise.name} (entreprise)"
    else
      super
    end
  end

  def profile
    return expert if expert
    return entreprise if entreprise
  end

  # def active_for_authentication?
  #   super && approved?
  # end

  # def inactive_message
  #   if !approved?
  #     :not_approved
  #   else
  #     super # Use whatever other message
  #   end
  # end
end
