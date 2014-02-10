class UserMailer <BaseMailer
  def account_confirmation_email(user)
    @user = user
    mail(:to => user.email, :subject => "Account confirmation request")
  end

  def password_reset_instructions(user)
    @user=user
    @edit_password_reset_url=edit_password_reset_url(user.perishable_token)
    mail(:to=> user.email, :subject=>"Password Reset Instructions")

  end
end
