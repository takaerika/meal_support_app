class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: { patient: 0, supporter: 1 }

  scope :alive, -> { where(deleted_at: nil) }
  scope :deleted, -> { where.not(deleted_at: nil) }
  scope :order_by_last_meal, -> {
    if ActiveRecord::Base.connection.column_exists?(:users, :last_meal_updated_at)
      order(Arel.sql('users.last_meal_updated_at IS NULL, users.last_meal_updated_at DESC'))
    else
      left_joins(:meal_records)
        .group('users.id')
        .order(Arel.sql('MAX(meal_records.updated_at) IS NULL, MAX(meal_records.updated_at) DESC'))
    end
  }

  has_one :invite_code, foreign_key: :supporter_id, dependent: :destroy

has_many :support_links_as_supporter,       class_name: "SupportLink", foreign_key: :supporter_id
has_many :support_links_as_supporter_alive, -> { where(deleted_at: nil) }, class_name: "SupportLink", foreign_key: :supporter_id
has_many :patients, -> { where(users: { deleted_at: nil }) },
         through: :support_links_as_supporter_alive, source: :patient

has_many :support_links_as_patient,         class_name: "SupportLink", foreign_key: :patient_id
has_many :support_links_as_patient_alive,   -> { where(deleted_at: nil) }, class_name: "SupportLink", foreign_key: :patient_id
has_many :supporters, -> { where(users: { deleted_at: nil }) },
         through: :support_links_as_patient_alive, source: :supporter
  has_many :meal_records, foreign_key: :patient_id, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates :first_name, :last_name, presence: true
  with_options if: :patient? do
    validates :last_name_kana,  presence: true, format: { with: /\A[ァ-ヶー　]+\z/, message: "はカタカナで入力してください" }
    validates :first_name_kana, presence: true, format: { with: /\A[ァ-ヶー　]+\z/ }
  end

  before_validation :normalize_kana
  before_validation :normalize_email
  after_commit :ensure_invite_code!, on: :create
  after_commit :soft_unlink_support_relations, if: :just_soft_deleted?

  def ensure_invite_code!
    return unless supporter?
    InviteCode.create!(supporter: self)
  end

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

  def normalize_email
    self.email = email.to_s.downcase.strip
  end

  def normalize_kana
    %i[last_name_kana first_name_kana].each do |attr|
      next unless self[attr].present?
      s = self[attr].to_s.strip
      s = s.tr('ぁ-ん', 'ァ-ン').gsub(/\s+/, ' ')
      self[attr] = s
    end
  end

  def just_soft_deleted?
    saved_change_to_deleted_at? && deleted_at.present?
  end

  def soft_unlink_support_relations
    now = Time.current
    support_links_as_supporter.where(deleted_at: nil).update_all(deleted_at: now, updated_at: now)
    support_links_as_patient.where(deleted_at: nil).update_all(deleted_at: now, updated_at: now)
  end
end