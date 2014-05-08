# == Schema Information
#
# Table name: invitations
#
#  id         :integer          not null, primary key
#  expert_id  :integer
#  mission_id :integer
#  state      :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Invitation do
  pending "add some examples to (or delete) #{__FILE__}"
end
