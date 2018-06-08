class PostsController < ApplicationController
    before_action :require_login

    def index
        @posts = Post.select("posts.id, posts.title, posts.body, posts.created_at, posts.updated_at, posts.user_id, users.email").joins(:user).order("posts.id DESC")

    end

    def create
        #render plain: params[:post].inspect
        @post = current_user.posts.build(post_params)

        if @post.save
            redirect_to post_path(@post), notice: "Post Created!"

        else
            @errors = @post.errors.full_messages
            render :new

        end

    end

    def new


    end

    def edit
        @post = current_user.posts.find(params[:id])

    end

    def show
        # Query for post
        @post = Post.select("posts.id, posts.title, posts.body, posts.created_at, posts.updated_at, posts.user_id, users.email").joins(:user).where(params[:id]).last
        puts @post.body
        #@post = Post.find(params[:id])

        # Query for user + comments
        @comments = Comment.select("comments.id, comments.body, comments.post_id, comments.user_id, comments.created_at, comments.updated_at, users.email").joins(:user).where("comments.post_id=?", params[:id]).order("comments.id DESC")
    end

    def update
        @post = current_user.posts.find(params[:id])

        if @post.update_attributes(post_params)
            redirect_to post_path(@post), notice: "Post Updated!"

        else
            @errors = @post.errors.full_messages
            render :edit

        end
    end

    def destroy

        post = current_user.posts.find(params[:id])
        #post = current_user.posts.find(params[:id])
        if post.destroy
            redirect_to posts_path, notice: "Deleted Post: #{post.title}"
        else
            @errors = @post.errors.full_messages
            render :delete
        end

    end

    private

    def  post_params
        params.require(:post).permit(:title, :body)
    end



end
