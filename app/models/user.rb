class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: { patient: 0, supporter: 1 }

  # 招待コード（サポーター側）
  has_one  :invite_code, foreign_key: :supporter_id, dependent: :destroy

  # 紐づけ
  has_many :support_links_as_supporter, class_name: "SupportLink",
           foreign_key: :supporter_id, dependent: :destroy
  has_many :patients, through: :support_links_as_supporter, source: :patient

  has_many :support_links_as_patient, class_name: "SupportLink",
           foreign_key: :patient_id, dependent: :destroy
  has_many :supporters, through: :support_links_as_patient, source: :supporter

  validates :first_name, :last_name, presence: true

  after_commit :ensure_invite_code!, on: :create

  def ensure_invite_code!
    return unless supporter?
    InviteCode.create!(supporter: self) # codeはInviteCode側で自動生成
  end

  before_validation :normalize_email
  def full_name = "#{last_name} #{first_name}"
  
  private
  def normalize_email; self.email = email.to_s.downcase.strip; end
end