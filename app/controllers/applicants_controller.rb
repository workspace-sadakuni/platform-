class ApplicantsController < ApplicationController
  before_action :authenticate_user

  def create
    @applicant = Applicant.new(user_id: @current_user.id, post_id: params[:post_id])
    @applicant.save
    redirect_to("/posts/#{params[:post_id]}")
  end

  def destroy
    @applicant = Applicant.find_by(user_id: @current_user.id, post_id: params[:post_id])
    @applicant.destroy
    redirect_to("/posts/#{params[:post_id]}")
  end

  def achieved
    @applicant = Applicant.find_by(user_id: @current_user.id, post_id: params[:post_id])
    if @applicant
      @applicant.achieved = "t"
      @applicant.save
      redirect_to("/posts/#{params[:post_id]}")
    else
      flash[:notice] = "先に挙手ボタンを押す必要があります"
      redirect_to("/posts/#{params[:post_id]}")
    end
  end

  def destroy_achieved
    @applicant = Applicant.find_by(user_id: @current_user.id, post_id: params[:post_id])
    @applicant.achieved = "f"
    @applicant.save
    redirect_to("/posts/#{params[:post_id]}")
  end
  
end