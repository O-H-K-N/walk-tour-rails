# == Schema Information
#
# Table name: videos
#
#  id           :bigint           not null, primary key
#  published_at :datetime         not null
#  thumbnail    :string           not null
#  title        :string           not null
#  view_count   :integer          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  spot_id      :bigint           not null
#  video_id     :string           not null
#
# Indexes
#
#  index_videos_on_spot_id  (spot_id)
#
# Foreign Keys
#
#  fk_rails_...  (spot_id => spots.id)
#
class Video < ApplicationRecord
  belongs_to :spot

  #
  # 10日以内に更新されたか
  #
  def recently_updated?
    updated_at > Time.current.days_ago(10)
  end
end
