class Micropost < ApplicationRecord
  belongs_to :user
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: Settings.content_max}
  validate :picture_size
  scope :newest, -> {order created_at: :desc}

  private

  def picture_size
    if picture.size > Settings.picture_size.megabytes
      errors.add(:picture, t("micropost.error_picture"))
    end
  end
end
