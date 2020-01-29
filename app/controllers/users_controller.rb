class UsersController < ApplicationController
	before_action :authenticate_user, {only: [:index, :show, :edit, :update]}
	before_action :forbid_login_user, {only: [:new, :create, :login_form, :login]}
	before_action :ensure_correct_user, {only: [:edit, :update]}

  def index
  	@users = User.all
  end

  def show
  	@user = User.find_by(id: params[:id])
  end

  def new
  	@user = User.new
  end

  def create
  	@user = User.new(name: params[:name], email: params[:email], image_name: "default_user.jpg",password: params[:password])
		if @user.save
			session[:user_id] = @user.id
  		flash[:notice] = "アカウントが作成されました"
  		redirect_to("/users/#{@user.id}")
  	else
  		render("users/new")
		end
	end

	def create_twitter
    # 下記Twitterでの新規ログイン処理
    user = User.find_or_create_from_auth_hash(request.env['omniauth.auth']) #request.env['omniauth.auth']はTwitter認証で得た情報が格納
		if user
			session[:user_id] = user.id
			flash[:notice] = "こんにちは#{user.name}さん！"
      redirect_to('/posts/index')
		else
			flash[:notice] = "ログインに失敗しました"
      redirect_to root_path
    end

  end

  def edit
  	@user = User.find_by(id: params[:id])
  end

  def update
  	@user = User.find_by(id: params[:id])
  	@user.name = params[:name]
		@user.email = params[:email]
		@user.password = params[:password]

  	if params[:image]
  		@user.image_name = "#{@user.id}.jpg"
  		image = params[:image]
  		File.binwrite("public/user_images/#{@user.image_name}", image.read)
  	end
  	if @user.save
  		flash[:notice] = "ユーザー情報を変更しました"
  		redirect_to("/users/#{@user.id}")
  	else
  		render("users/edit")
  	end
	end

	def destroy
		@user = User.find_by(id: params[:id])
		@posts = Post.where(user_id: @user.id)
		@applicants = Applicant.where(user_id: @user.id)
		if	@user.destroy
			@posts.destroy_all
			@applicants.destroy_all
			flash[:notice] = "アカウントを削除しました"
			redirect_to("/signup")
		else
			render("users/edit")
		end
	end
	
	def login_form
	end

	def login
		@user = User.find_by(email: params[:email])
		if @user && @user.authenticate(params[:password])
			session[:user_id] = @user.id
			flash[:notice] = "こんにちは#{@user.name}さん！"
			redirect_to("/posts/index")
		else
			@error_message = "メールアドレスまたはパスワードが間違っています"
			@email = params[:email]
			@password = params[:password]
			render("users/login_form")
		end
	end

	def logout
		session[:user_id] = nil
		flash[:notice] = "ログアウトしました"
		redirect_to("/login")
	end

	def applicants
		@user = User.find_by(id: params[:id])
		@applicants = Applicant.where(user_id: @user.id)
	end

	def ensure_correct_user
		if @current_user.id != params[:id].to_i
			flash[:notice] = "権限がありません"
			redirect_to("/posts/index")
		end
	end

end
