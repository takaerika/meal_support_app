class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: { patient: 0, supporter: 1 }
  scope :alive, -> { where(deleted_at: nil) }
  scope :deleted, -> { where.not(deleted_at: nil) }

  # 招待コード（サポーター側）
  has_one  :invite_code, foreign_key: :supporter_id, dependent: :destroy

  # 紐づけ
  has_many :support_links_as_supporter, class_name: "SupportLink",
           foreign_key: :supporter_id, dependent: :destroy
  has_many :patients, through: :support_links_as_supporter, source: :patient

  has_many :support_links_as_patient, class_name: "SupportLink",
           foreign_key: :patient_id, dependent: :destroy
  has_many :supporters, through: :support_links_as_patient, source: :supporter
  has_many :meal_records, foreign_key: :patient_id, dependent: :destroy
  has_many :comments, dependent: :destroy
  validates :first_name, :last_name, presence: true
  with_options if: :patient? do
    validates :last_name_kana,  presence: true, format: { with: /\A[ァ-ヶー　]+\z/, message: "はカタカナで入力してください" }
    validates :first_name_kana, presence: true, format: { with: /\A[ァ-ヶー　]+\z/ }
  end

  before_validation :normalize_kana
  after_commit :ensure_invite_code!, on: :create

  def ensure_invite_code!
    return unless supporter?
    InviteCode.create!(supporter: self) # codeはInviteCode側で自動生成
  end

  before_validation :normalize_email
  def full_name = "#{last_name} #{first_name}"
  
  def last_name_with_san
    "#{last_name}さん"
  end

  def soft_delete!
    update!(deleted_at: Time.current)
  end

  def active_for_authentication?
    super && deleted_at.nil?
  end

  def inactive_message
    deleted_at? ? :deleted_account : super
  end
  
  private
  def normalize_email; self.email = email.to_s.downcase.strip; end

  def normalize_kana
    %i[last_name_kana first_name_kana].each do |attr|
      next unless self[attr].present?
      s = self[attr].to_s.strip
      # ひらがな → カタカナ / 全角スペースの整形
      s = s.tr('ぁ-ん', 'ァ-ン').gsub(/\s+/, ' ')
      self[attr] = s
    end
  end
end