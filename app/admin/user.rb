# encoding: utf-8
ActiveAdmin.register User do

  controller do

    def update
      user = User.find(params[:id])
      user.skip_confirmation!
      user.skip_confirmation_notification!
      user.skip_reconfirmation!
      user.email = params[:user][:email]
      user.save
      redirect_to admin_user_path(user.id)
    end

    def permitted_params
      params.permit(user: [:email])
    end
  end
end
