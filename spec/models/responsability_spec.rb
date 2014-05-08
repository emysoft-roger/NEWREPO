# == Schema Information
#
# Table name: responsabilities
#
#  id          :integer          not null, primary key
#  organisme   :string(255)
#  poste       :string(255)
#  description :text
#  expert_id   :integer
#  created_at  :datetime
#  updated_at  :datetime
#

require 'spec_helper'

describe Responsability do
  pending "add some examples to (or delete) #{__FILE__}"
end
