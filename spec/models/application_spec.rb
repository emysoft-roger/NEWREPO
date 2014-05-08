# == Schema Information
#
# Table name: applications
#
#  id               :integer          not null, primary key
#  expert_id        :integer
#  mission_id       :integer
#  motivation       :text
#  state            :integer
#  created_at       :datetime
#  updated_at       :datetime
#  price            :float
#  entreprise_price :float
#

require 'spec_helper'

describe Application do
  pending "add some examples to (or delete) #{__FILE__}"
end
