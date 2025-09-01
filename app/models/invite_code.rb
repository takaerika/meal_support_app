class InviteCode < ApplicationRecord
  belongs_to :supporter, class_name: "User"
  CANDIDATES = ('A'..'Z').to_a + ('0'..'9').to_a - %w[O 0 I 1] # 読みにくい文字は除外
  before_validation :ensure_code, on: :create

  validates :code, presence: true, uniqueness: true,
                   format: { with: /\A[A-Z0-9]{6}\z/ }

  private
  def ensure_code
    return if code.present?
    # 重複に備えて数回チャレンジ
    10.times do
      candidate = Array.new(6) { CANDIDATES.sample }.join
      unless InviteCode.exists?(code: candidate)
        self.code = candidate
        break
      end
    end
  end
end