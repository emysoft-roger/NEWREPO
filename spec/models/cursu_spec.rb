# == Schema Information
#
# Table name: cursus
#
#  id         :integer          not null, primary key
#  diplome    :string(255)
#  university :string(255)
#  years      :integer
#  expert_id  :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Cursu do
  pending "add some examples to (or delete) #{__FILE__}"
end
