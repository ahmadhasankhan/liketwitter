class UsersController < ApplicationController
  # GET /users
  # GET /users.xml
  before_filter :login_user, :except => [:new, :create, :destroy, :welcome]
  before_filter :authorised_user, :only => [:index,]
  before_filter :un_authorised_user, :only => [:new]


  def index
    @users = User.all
    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @users }

    end
  end

# GET /users/1
# GET /users/1.xml
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @user }
    end
  end

# GET /users/new
# GET /users/new.xml
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml { render :xml => @user }
    end
  end

# GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

# POST /users
# POST /users.xml
  def create

    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to(root_path, :notice => 'Registration successfull.') }
        format.xml { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

# PUT /users/1
# PUT /users/1.xml
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])

        format.html { redirect_to(@user, :notice => 'User was successfully updated.') }
        format.xml { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

# DELETE /users/1
# DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml { head :ok }
    end
  end

  def accessdenied

  end

  def changepassword
    @user=current_user
  end

  def updatepassword
    @user = User.find(params[:user][:id])
    User.ignore_blank_passwords=false
    if @user.update_attributes(params[:user])
      flash[:notice] = "Password changed successfully"
      redirect_to changepassword_users_url
    else
      render :action => :changepassword
    end

  end

  def public_profile
    @user=User.find_by_username(params[:uid])
    if @user
      @followers = @user.followers
      @following = Follower.find_all_by_follower_id(@user.id)
      if !@followers.blank?
        @am_i_following=@followers.where("follower_id=?", current_user.id)
      end

      @tweets = @user.tweets
      @retweets=@user.get_retweed_list
      if !@retweets.blank?
        @tweets= @tweets | @retweets
      end
    end

    if !@user
      redirect_to root_path
      flash[:alert] = "No User Found With This Name #{params[:uid]}"
    end
  end

  def welcome
    if current_user
      @followers = current_user.followers
      @following = Follower.find_all_by_follower_id(current_user.id)
      @tweets = Tweet.all
      @retweets=current_user.get_retweed_list
      if !@retweets.blank?
        @tweets= @tweets | @retweets
      end
    end
  end

  def follow
    @going_to_follow = User.find(params[:user_id])
    isFollowing = Follower.where("user_id=? and follower_id=?", @going_to_follow.id, current_user.id)
    if @going_to_follow != current_user && isFollowing.blank?
      @activity = Follower.create(:user_id => @going_to_follow.id, :follower_id => current_user.id)
      redirect_to :back
    else
      if !isFollowing.blank?
        isFollowing.destroy_all
      end
      redirect_to :back
    end
  end
end


