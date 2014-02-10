# app/controllers/password_resets_controller.rb
class PasswordResetsController < ApplicationController
  before_filter :un_authorised_user
  before_filter :load_user_using_perishable_token, :only => [:edit, :update]

  def new
    if params[:resend]
      @page_title=(t 'password_reset.new.resend_mail')
    else
      @page_title=(t 'password_reset.new.reset_passwors')
    end
    render
  end

  def create
    @user = User.find_by_email(params[:email])
    if @user
      if params[:resend]
        if !@user.confirmed?
          @user.send_account_confirmation_mail
          flash[:notice] = "Instructions have been emailed to you. " +
              "Please check your email."
          redirect_to root_url
        else
          flash[:alert] = "This email already confirmed."
          render :action => :new
        end
      else
        @user.deliver_password_reset_instructions!
        flash[:notice] = "Instructions to reset your password have been emailed to you. " +
            "Please check your email."
        redirect_to root_url
      end

    else
      flash[:alert] = "No user was found with that email address"
      render :action => :new
    end
  end


  def edit
    render
  end

  def update
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]
    if @user.save
      flash[:notice] = "Password successfully updated"
      redirect_to root_url
    else
      render :action => :edit
    end
  end

  private
  def load_user_using_perishable_token
    @user = User.find_using_perishable_token(params[:id])
    unless @user
      flash[:alert] = "We're sorry, but we could not locate your account. " +
          "If you are having issues try copying and pasting the URL " +
          "from your email into your browser or restarting the " +
          "reset password process."
      redirect_to root_url
    end
  end
end