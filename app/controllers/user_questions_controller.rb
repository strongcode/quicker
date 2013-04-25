class UserQuestionsController < ApplicationController

  before_filter :authenticate_user!

  def new
    @user_question = @profile_user.build_user_question
  end

  def create
    @user_question = @profile_user.build_user_question(params[:user_question])
    if @user_question.save
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
    @user_question = @profile_user.user_question.find params[:id]
  end

  def update
    @user_question = @profile_user.user_question.find params[:id]
    if @user_question.update_attributes(params[:user_question])
      redirect_to root_url
    else
      render 'edit'
    end
  end
  
end
