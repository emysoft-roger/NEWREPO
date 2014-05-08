# encoding: utf-8
require 'spec_helper'
require 'factory_girl'
# FactoryGirl.find_definitions

describe MissionsController do

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

    it "should assigns" do
      get :index
      assigns(:missions).should_not be_nil
      response.status.should be(200)
    end

    it "should filter" do
      get :index, secteur: 123_456, competence: 3
      assigns(:missions).size.should be(0)
      response.status.should be(200)
    end
  end
  describe "inscription" do
    context "valid attributes" do
      it "creates and redirect to new_mission " do
        # pending "wait"

        expect do
          post :create_entreprise,
               entreprise: FactoryGirl.attributes_for(:entreprise) ,
               user: FactoryGirl.attributes_for(:user),
               validate: true
        end.to change(Entreprise, :count).by(1)

        expect do
          post :create_entreprise,
               entreprise: FactoryGirl.attributes_for(:entreprise) ,
               user: FactoryGirl.attributes_for(:user),
               validate: true
        end.to change(ActionMailer::Base.deliveries, :count).by(1)

        ActionMailer::Base.deliveries.last.to.should eq([assigns(:user).email])
        ActionMailer::Base.deliveries.last.subject.should_not be(nil)

        response.should redirect_to(new_mission_path)
      end

      it "creates and redirect to dashboard" do
        # pending "wait"

        expect do
          post :create_entreprise,
               entreprise: FactoryGirl.attributes_for(:entreprise) ,
               user: FactoryGirl.attributes_for(:user),
               dashboard: true
        end.to change(Entreprise, :count).by(1)

        ActionMailer::Base.deliveries.last.to.should eq([assigns(:user).email])

        response.should redirect_to(entreprise_dashboard_path(assigns(:entreprise)))
      end
    end

    context "invalid attributes" do
      it "should not redirect (invalid tel)" do
        pending "wait"

        expect do
          post :create_entreprise,
               entreprise: FactoryGirl.attributes_for(:invalid_entreprise),
               user: FactoryGirl.attributes_for(:user),
               validate: true
        end.to_not change(Entreprise, :count).by(1)

        response.should redirect_to(new_mission_path)
      end
    end
  end

  describe "manage mission" do
    context "valid attributes" do
      it "should create mission " do
      # pending "wait"

        @entreprise = sign_in_entreprise
        request.env["HTTP_REFERER"] = entreprise_dashboard_url(@entreprise)

        get :new

        assigns(:categories).should_not be_nil
        assigns(:secteurs).should_not be_nil
        assigns(:competences).should_not be_nil

        response.status.should be(200)
        budget_list = [
          "0-2000",
          "2000-5000",
          "5000-10000",
          "10000-50000",
          "50000-500000"
        ]

        duree_list = [
          "0-4",
          "4-12",
          "12-24",
          "24-52",
          "52-520"
        ]

        first_attr = FactoryGirl.attributes_for(:mission)

        sec_attr = { budget: budget_list.sample,
                     duree: duree_list.sample,
                     category_id: rand(1..5),
                     secteur_id: rand(1..8),
                     competence_id: rand(1..17) }

        @mission_attr = first_attr.merge(sec_attr)

        expect do
          post :create, mission: @mission_attr
        end.to change(Mission, :count).by(1)

        response.should redirect_to(preview_path(assigns(:mission)))
      end

      it "should update mission" do
      # pending "wait"

        entreprise = sign_in_entreprise

        @mission = Mission.create(FactoryGirl.attributes_for(:pending_missions,
                                                             entreprise_id: entreprise.id))

        mail_count = ActionMailer::Base.deliveries.count

        expect do
          patch :update, id: @mission.id
        end.to change(ActionMailer::Base.deliveries, :count).by(2)


        ActionMailer::Base.deliveries[mail_count].to.should eq(@admins_emails)
        ActionMailer::Base.deliveries[mail_count].subject.should include(@mission.name)

        ActionMailer::Base.deliveries.last.to.should eq([entreprise.user.email])
        ActionMailer::Base.deliveries.last.subject.should include("Mission")

        response.should redirect_to(entreprise_dashboard_path(entreprise.id))
      end

      it "should delete mission" do
      # pending "wait"

        @entreprise = sign_in_entreprise

        @mission = Mission.create(FactoryGirl.attributes_for(:pending_missions,
                                                             entreprise_id: @entreprise.id))

        request.env["HTTP_REFERER"] = entreprise_dashboard_url(@entreprise)

        expect do
          delete :delete, id: @mission.id
        end.to change(Mission, :count).by(-1)

        response.should redirect_to(:back)
      end

      it "should confirm mission" do
      # pending "wait"

        @entreprise = sign_in_entreprise
        sign_out_user(@entreprise.user)
        @expert = sign_in_expert

        @mission = Mission.create(FactoryGirl.attributes_for(:pending_missions,
                                                             entreprise_id: @entreprise.id,
                                                             expert_id: @expert.id))

        expect do
          patch :expert_confirm, id: @mission.id, confirm: true, infos_bancaire: {}
        end.to change(ActionMailer::Base.deliveries, :count).by(3)

        mail_count = ActionMailer::Base.deliveries.count

        ActionMailer::Base.deliveries[mail_count - 2].to.should eq([@entreprise.user.email])
        ActionMailer::Base.deliveries.last.to.should eq([@expert.user.email])

        response.should redirect_to(dashboard_path(@expert))
      end

      it "should reject mission" do
      # pending "wait"

        @entreprise = sign_in_entreprise
        sign_out_user(@entreprise.user)
        @expert = sign_in_expert

        @mission = Mission.create(FactoryGirl.attributes_for(:pending_missions,
                                                             entreprise_id: @entreprise.id,
                                                             expert_id: @expert.id))

        request.env["HTTP_REFERER"] = dashboard_url(@expert)

        expect do
          patch :expert_confirm, id: @mission.id, confirm: false
        end.to change(ActionMailer::Base.deliveries, :count).by(1)

        ActionMailer::Base.deliveries.last.to.should eq([@entreprise.user.email])

        response.should redirect_to(:back)
      end

      it "should create note" do
      # pending "wait"

        @expert = sign_in_expert
        sign_out_user(@expert.user)
        @entreprise = sign_in_entreprise

        @mission = Mission.create(FactoryGirl.attributes_for(:pending_missions,
                                                             entreprise_id: @entreprise.id))

        expect do
          post :create_note,
               note: FactoryGirl.attributes_for(:note,
                                                expert_id: @expert.id,
                                                mission_id: @mission.id)
        end.to change(Note, :count).by(1)

        response.should redirect_to(entreprise_dashboard_path(@entreprise.id))
      end
    end

    context "invalid attributes" do
      it "shouldn't create mission (category miss)" do
      # pending "wait"

        entreprise = sign_in_entreprise

        expect do
          post :create,
               mission: FactoryGirl.attributes_for(:invalid_mission,
                                                   entreprise_id: entreprise.id)
        end.to_not change(Mission, :count).by(1)
      end
    end
  end

  describe "entreprise_dashboard" do
    it "should get pending expert-missions" do
      # pending "wait"

      expert = sign_in_expert
      sign_out_user(expert.user)
      entreprise = sign_in_entreprise

      mission1 = Mission.create(FactoryGirl.attributes_for(:pending_expert_missions,
                                                           entreprise_id: entreprise.id,
                                                           expert_id: expert.id))

      mission2 = Mission.create(FactoryGirl.attributes_for(:pending_admin,
                                                           entreprise_id: entreprise.id))


      get :dashboard, id: entreprise.id

      assigns(:pending_missions_admin).last.should_not be_nil
      assigns(:pending_missions_admin).last.id.should eq(mission2.id)

      assigns(:pending_expert_missions).last.should_not be_nil
      assigns(:pending_expert_missions).last.id.should eq(mission1.id)

      assigns(:actives_mission).last.should be_nil
      assigns(:done_mission).last.should be_nil
    end
  end

  describe "manage application" do
    it "should create application" do
      # pending "wait"

      @entreprise = sign_in_entreprise

      @mission = Mission.create(FactoryGirl.attributes_for(:pending_missions,
                                                           entreprise_id: @entreprise.id))

      sign_out_user(@entreprise.user)

      @expert = sign_in_expert
      request.env["HTTP_REFERER"] = mission_url(@mission.id)

      @invitation = Invitation.create(expert_id: @expert.id,
                                      mission_id: @mission.id,
                                      state: 0)


      get :application, id: @mission.id
      assigns(:mission).should eq(@mission)

      expect do
        post :create_application,
             application: FactoryGirl.attributes_for(:application,
                                                     mission_id: @mission.id),
             id: @mission.id
      end.to change(Application, :count).by(1)

      expect do
        post :create_application,
             application: FactoryGirl.attributes_for(:application,
                                                     mission_id: @mission.id),
             id: @mission.id,
             invitation_id: @invitation.id
      end.to change(ActionMailer::Base.deliveries, :count).by(2)

        mail_count = ActionMailer::Base.deliveries.count

        ActionMailer::Base.deliveries[mail_count-2].to.should eq([@expert.user.email])
        ActionMailer::Base.deliveries.last.to.should eq([@entreprise.user.email])

      response.should redirect_to(dashboard_path(@expert))
    end

    it "should confirm application" do
      # pending "wait"

      @expert = sign_in_expert
      sign_out_user(@expert.user)
      @entreprise = sign_in_entreprise

      @mission = Mission.create(FactoryGirl.attributes_for(:pending_missions,
                                                           entreprise_id: @entreprise.id))

      @application = Application.create(FactoryGirl.attributes_for(:application,
                                                                   mission_id: @mission.id,
                                                                   expert_id: @expert.id,
                                                                   state: 0))

      expect do
        patch :confirm, id: @application.id
      end.to change(ActionMailer::Base.deliveries, :count).by(2)

      mail_count = ActionMailer::Base.deliveries.count

      ActionMailer::Base.deliveries[mail_count-2].to.should eq([@entreprise.user.email])
      ActionMailer::Base.deliveries.last.to.should eq([@expert.user.email])

      response.should redirect_to(entreprise_dashboard_path(@entreprise.id))
    end

    it "should delete application" do
      # pending "wait"

      @entreprise = sign_in_entreprise
      sign_out_user(@entreprise.user)
      @expert = sign_in_expert

      @mission = Mission.create(FactoryGirl.attributes_for(:pending_missions,
                                                           entreprise_id: @entreprise.id))

      @application = Application.create(FactoryGirl.attributes_for(:application,
                                                                   mission_id: @mission.id,
                                                                   expert_id: @expert.id,
                                                                   state: 0))

      request.env["HTTP_REFERER"] = dashboard_url(@expert)

      expect do
        delete :delete_application, id: @application.id
      end.to change(Application, :count).by(-1)

      response.should redirect_to(:back)
    end
  end
end
