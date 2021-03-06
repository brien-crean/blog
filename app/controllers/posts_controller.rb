class PostsController < ApplicationController

  before_action :authenticate_user, only: [:new, :create, :edit, :destroy]

  before_action :authorize, only: [:edit, :update, :destroy]

  def index
    # @posts = Post.all
    @posts = Post.search(params[:search]).order("updated_at DESC")
    DailyCommentSummaryJob.perform_later

  end

  def new
    @post = Post.new
  end

  def create
    new_post =  params.require(:post).permit([:title, :body, {tag_ids: []}, :image])

    @post = Post.new(new_post)
    @post.user = current_user

    if @post.save
    redirect_to post_path(@post), notice: "Post Created!"
    else
      render :new
    end
  end

  def show
    @post = Post.find(params[:id])

    # init @comment instance var so it is not nil when views/post/show.html.erb loads
    @comment = Comment.new
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    # find question to update
    @post = Post.find(params[:id])

    # grab input from form
    new_post =  params.require(:post).permit([:title, :body, {tag_ids: []}, :image])

    if @post.update(new_post)
      redirect_to post_path(@post), notice: "Post updated!"
    else
      render :edit
    end
  end

  def destroy
    @post = Post.find(params[:id])

    @post.destroy

    redirect_to posts_path, alert: "Post deleted!"

  end

  def vote_up
    # note sure how to call this method or what to add
  end

  def search
    @posts = Post.search(params[:search])
    # render text: @posts.each {|post| puts post.title}
  end

  def authorize
  @post = Post.find(params[:id])
  redirect_to root_path, alert: "Access denied!" unless can? :manage, @post
  end

end
