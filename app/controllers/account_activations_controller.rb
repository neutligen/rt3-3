class AccountActivationsController < ApplicationController
  
   def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      flash[:success] = "メールアドレスの確認がとれたので。アカウントが有効になりました。"
      redirect_to user
    else
      flash[:danger] = "リンクが無効になっております。恐れ入りますが、もう一度初めからやり直してください。"
      redirect_to root_url
    end
   end
end
