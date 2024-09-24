class DeletePostWorker < ActiveJob::Base
  queue_as :default

  def perform(post_id)
    puts "Processing post with ID: #{post_id}"
    Post.destroy(post_id)
    Sidekiq::Cron::Job.destroy("Delete Post #{post_id} - after 24h")
  end
end
