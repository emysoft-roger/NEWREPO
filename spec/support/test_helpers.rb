module TestHelpers
  def sign_in_expert
    @request.env["devise.mapping"] = Devise.mappings[:user]
    user = FactoryGirl.create(:user)
    user.approved = true
    user.confirm!

    expert = Expert.new(FactoryGirl.attributes_for(:expert))
    expert.user_id = user.id
    expert.save

    sign_in user
    expert
  end

  def sign_in_entreprise
    @request.env["devise.mapping"] = Devise.mappings[:user]
    user = FactoryGirl.create(:user)
    user.approved = true
    user.confirm!

    entreprise = Entreprise.new(FactoryGirl.attributes_for(:entreprise))
    entreprise.user_id = user.id
    entreprise.save

    sign_in user
    entreprise
  end

  def sign_out_user(user)
      sign_out user
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    @current_user
  end
end
