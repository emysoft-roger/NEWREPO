# encoding: utf-8
require 'spec_helper'
require 'factory_girl'
FactoryGirl.find_definitions

describe ExpertsController do
  # integrate_views

  # let(:valid_attributes) { { "competence" => "" } }
  let(:valid_session) { {}}

  before :all do
    # @admins_count.times do
      # FactoryGirl.build(:admin_user)
    # end
    # @admins_count = 4
    @admins = AdminUser.all
    @admins_count = @admins.count
    @admins_emails = @admins.pluck(:email)
  end

  describe "index" do
    it "should render" do
      get :index
      response.status.should be(200)
    end

    it "should assigns experts" do
      get :index
      assigns(:experts).should_not be_nil
      response.status.should be(200)
    end

    it "should filter" do
      get :index, secteurs: [123_456], competences: []
      assigns(:experts).size.should be(0)
      response.status.should be(200)
    end

    it "should search" do
      get :index, secteurs: [1], competences: [2]
      assigns(:selected_elem).size.should be(2)
      assigns(:selected_elem)[0].should eq(["1"])
      assigns(:selected_elem)[1].should eq(["2"])

      response.status.should be(200)
    end
  end

  describe "inscription" do
    context "valid attributes" do

      it "creates and redirect to new_profile" do
        # pending "wait"
        mail_count = ActionMailer::Base.deliveries.count

        expect do
          post :create, expert: FactoryGirl.attributes_for(:expert),
                        user: FactoryGirl.attributes_for(:user),
                        validate: true
        end.to change(Expert, :count).by(1)

        ActionMailer::Base.deliveries[mail_count].to.should eq(@admins_emails)
        ActionMailer::Base.deliveries[mail_count + 1].to
                                                     .should eq([assigns(:user).email])

        response.should redirect_to(new_profile_path(assigns(:expert)))
      end

      it "creates and redirect to dashboard" do
        # pending "wait"

        expect do
          post :create, expert: FactoryGirl.attributes_for(:expert),
                        user: FactoryGirl.attributes_for(:user),
                        dashboard: true
        end.to change(Expert, :count).by(1)

        response.should redirect_to(dashboard_path(assigns(:expert)))
      end
    end

    context "invalid attributes" do
      it "not creates and not redirect (invalid email)" do
        # pending "wait"

        expect do
          post :create, expert: FactoryGirl.attributes_for(:expert),
                        user: FactoryGirl.attributes_for(:invalid_user),
                        validate: true
        end.to_not change(User, :count).by(1)

        response.should render_template :new
      end

      it "not creates and not redirect (invalid tel)" do
        pending "wait"

        expect do
          post :create, expert: FactoryGirl.attributes_for(:invalid_expert),
                        user: FactoryGirl.attributes_for(:user),
                        validate: true
        end.to_not change(Expert, :count).by(1)

        response.should render_template :new
      end
    end
  end

  describe "create profile" do
    context "valid attributes" do
      it "complete expert profile " do
        # pending "wait"

        expect do
          @expert = sign_in_expert
        end.to change(ActionMailer::Base.deliveries, :count).by(2)

        ActionMailer::Base.deliveries.last.to.should eq(@admins_emails)

        get :new_profile, id: @expert.id
        response.status.should be(200)

        @expert_attr = { id: @expert.id,
                         profile_title: Faker::Lorem.sentence,
                         services: Faker::Lorem.paragraph
        }

        post :create_profile,
             expert: @expert_attr,
             expert_secteur: FactoryGirl.attributes_for(:expert_secteur),
             expert_competence: FactoryGirl.attributes_for(:expert_competence),
             experience: FactoryGirl.attributes_for(:experience)

        response.should redirect_to(dashboard_path(assigns(:expert)))
      end
    end
  end

  describe "profile" do
    it "should get expert profile" do
      # pending "wait"

      @expert = sign_in_expert
      sign_out_user(@expert.user)
      @entreprise = sign_in_entreprise

      @mission = Mission.create(FactoryGirl.attributes_for(:pending_missions,
                                                           entreprise_id: @entreprise.id,
                                                           expert_id: @expert.id))

      get :profile, id: @expert.id

      assigns(:expert).should eq(@expert)
      # assigns(:missions).should_not be_nil
      # assigns(:missions).last.id.should == @mission.id

    end
  end

  describe "dashboard" do
    it "should get pending applications" do
      # pending "wait"

      @entreprise = sign_in_entreprise
      sign_out_user(@entreprise.user)
      @expert = sign_in_expert

      @mission = Mission.create(FactoryGirl.attributes_for(:done_missions,
                                                           entreprise_id: @entreprise.id,
                                                           expert_id: @expert.id))

      @application = Application.create(FactoryGirl.attributes_for(:pending_application,
                                                                   mission_id: @mission.id,
                                                                   expert_id: @expert.id))

      get :dashboard, id: @expert.id

      # assigns(:pending_applications).last.should_not be_nil
      # assigns(:pending_applications).last.id.should eq(@application.id)
      assigns(:missions_done).last.should_not be_nil

      assigns(:missions_done).last.id.should eq(@mission.id)

      assigns(:pending_confirm_missions).last.should be_nil
      assigns(:actives_mission).last.should be_nil
    end
  end

  describe "invitation" do
    it "should invit" do
      # pending "wait"

      @expert = sign_in_expert
      sign_out_user(@expert.user)
      @entreprise = sign_in_entreprise

      @mission = Mission.create(FactoryGirl.attributes_for(:pending_missions,
                                                           entreprise_id: @entreprise.id))

      expect do
        post :invit, id: @expert.id, mission_id: @mission.id
      end.to change(Invitation, :count).by(1)

      response.should redirect_to(entreprise_dashboard_path(@entreprise.id))
    end

    it "should refuse invitation" do
      # pending "wait"

      @entreprise = sign_in_entreprise
      sign_out_user(@entreprise.user)
      @expert = sign_in_expert

      @mission = Mission.create(FactoryGirl.attributes_for(:pending_missions,
                                                           entreprise_id: @entreprise.id))

      @invitation = Invitation.create(expert_id: @expert.id,
                                      mission_id: @mission.id,
                                      state: 0)

      request.env["HTTP_REFERER"] = "http://localhost:3000/" + dashboard_path(@expert)

      expect do
        patch :refused_invitation, id: @invitation.id
      end.to change(ActionMailer::Base.deliveries, :count).by(1)

      ActionMailer::Base.deliveries.last.to.should  eq([@entreprise.user.email])
      ActionMailer::Base.deliveries.last.subject.should include("expert")

      response.should redirect_to(:back)
    end
  end
end
