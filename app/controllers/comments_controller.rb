class CommentsController < ApplicationController
    before_action :require_login

    def create
        # Query to find post
        @post = Post.find(params[:post_id])

        # Query to create comment based on POST params
        @comment = @post.comments.create(params[:comment].permit(:body))
        @comment.user_id = current_user.id

        
        if @comment.save
            redirect_to post_path(@post), notice: "Comment Created!"
        else
            @errors = @comment.errors.full_messages
            render :new
        end
        # @comment = current_user.comments.create(comment_params)

        # Query to 
        #@comment = Comment.select("*").joins(:user).where("users.id=?", @comment.user_id).last

    end

    def edit
        @comment = current_user.comments.find(params[:id])

    end

    def update

        @comment = current_user.comments.find(params[:id])

        if @comment.update_attributes(comment_params)
            redirect_to post_path(@comment.post), notice: "Comment Updated!"

        else
            @errors = @comment.errors.full_messages
            render :edit

        end

    end

    def destroy
        @post = Post.find(params[:post_id])
        @comment = current_user.comments.find(params[:id])
        if @comment.destroy
            redirect_to post_path(@post), notice: "Comment deleted!"
        else
            @errors = @comment.errors.full_messages
            render :delete
        end

    end

    private def comment_params
        params.require(:comment).permit(:body)
    end

end
