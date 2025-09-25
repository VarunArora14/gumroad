# frozen_string_literal: true

class ReindexUserElasticsearchDataWorker
  include Sidekiq::Job
  sidekiq_options retry: 1, queue: :low, lock: :until_executed

  ADMIN_NOTE = "Refreshed ES Data"

  def perform(user_id, admin_id)
    user = User.find user_id
    admin = User.find admin_id

    DevTools.reindex_all_for_user(user.id)

    user.comments.create!(
      author_id: admin.id,
      author_name: admin.name,
      content: ADMIN_NOTE
    )
  end
end
