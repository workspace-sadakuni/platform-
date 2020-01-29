class PostsController < ApplicationController
	before_action :authenticate_user
	before_action :ensure_correct_user, {only: [:edit, :update, :destroy]}

  def index
  	@posts = Post.page(params[:page]).order(created_at: :desc)
  end

  def show
		@post = Post.find_by(id: params[:id])
		@user = @post.user
		@applicant_count = Applicant.find_by(post_id: @post.id)
		if @applicant_count
		@applicants_count = Applicant.where(post_id: @post.id).count
		@achieved_count = Applicant.where(post_id: @post.id, achieved: "t").count
		@achieved_percentage = sprintf("%.2f",@achieved_count.to_d / @applicants_count * 100)
		end
  end

  def new
  	@post = Post.new
  end

  def create
		@post = Post.new(content: params[:content], title: params[:title], started_at: params[:started_at], finish_at: params[:finish_at], user_id: @current_user.id)
    
		if @post.save
			@applicant = Applicant.new(user_id: @current_user.id, post_id: @post.id)
			@applicant.save
  		flash[:notice] = "投稿を作成しました"
  		redirect_to("/posts/index")
  	else
  		render("posts/new")
  	end
  end

  def edit
  	@post = Post.find_by(id: params[:id])
  end

  def update
  	@post = Post.find_by(id: params[:id])
  	@post.content = params[:content]
    @post.title = params[:title]
    @post.started_at = params[:started_at]
    @post.finish_at = params[:finish_at]
  	if @post.save
  		flash[:notice] = "投稿を編集しました"
  		redirect_to("/posts/index")
  	else
  		render("posts/edit")
  	end
  end

  def destroy
		@post = Post.find_by(id: params[:id])
		@applicants = Applicant.where(post_id: @post.id)
		
		if @applicants.destroy_all
			@post.destroy
  		flash[:notice] = "投稿を削除しました"
			redirect_to("/posts/index")
		end
	end
	
	def ensure_correct_user
    @post = Post.find_by(id: params[:id])
    if @post.user_id != @current_user.id
      flash[:notice] = "権限がありません"
      redirect_to("/posts/index")
    end
  end

end
