class User < ApplicationRecord
  # Devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one  :invite_code,  foreign_key: :supporter_id, dependent: :destroy
  has_many :support_links_as_supporter, class_name: "SupportLink", foreign_key: :supporter_id, dependent: :destroy
  has_many :patients, through: :support_links_as_supporter, source: :patient
  has_many :support_links_as_patient, class_name: "SupportLink", foreign_key: :patient_id, dependent: :destroy
  has_many :supporters, through: :support_links_as_patient, source: :supporter

  after_commit :ensure_invite_code!, on: :create
  def ensure_invite_code!
    return unless supporter?
    InviteCode.create!(supporter: self, code: SecureRandom.alphanumeric(6).upcase)
  end

  # 役割（0=患者, 1=サポーター）
  enum role: { patient: 0, supporter: 1 }

  # 氏名は必須
  validates :first_name, :last_name, presence: true

  # メール正規化（大文字/空白の吸収）
  before_validation :normalize_email

  # 表示用の氏名
  def full_name = "#{last_name} #{first_name}"

  private
  def normalize_email
    self.email = email.to_s.downcase.strip
  end
end