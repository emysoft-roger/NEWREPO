# == Schema Information
#
# Table name: experts
#
#  id            :integer          not null, primary key
#  first_name    :string(255)
#  last_name     :string(255)
#  tel           :string(255)
#  birthdate     :datetime
#  profile_title :string(255)
#  services      :text
#  user_id       :integer
#  created_at    :datetime
#  updated_at    :datetime
#  image_id      :string(255)
#

require 'spec_helper'

describe Expert do
end
