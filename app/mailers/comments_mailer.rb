class CommentsMailer < ApplicationMailer
  def notify_post_owner(comment)
    @comment = comment
    @post = @comment.post
    @owner = @post.user
    mail(to: @owner.email, subject: "You got a new comment on your post!")
  end
end
