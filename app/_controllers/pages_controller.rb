# encoding: utf-8
class PagesController < ApplicationController
  def post_contact
    AdminMailer.contact(params).deliver
    flash[:notice] = ""
    redirect_to :back
  end
end
