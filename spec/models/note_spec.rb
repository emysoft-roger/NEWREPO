# == Schema Information
#
# Table name: notes
#
#  id            :integer          not null, primary key
#  description   :text
#  ponctualite   :float
#  qualite       :float
#  disponibilite :float
#  courtoisie    :float
#  created_at    :datetime
#  updated_at    :datetime
#  expert_id     :integer
#  mission_id    :integer
#

require 'spec_helper'

describe Note do
  pending "add some examples to (or delete) #{__FILE__}"
end
