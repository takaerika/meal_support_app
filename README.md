# テーブル設計

## users テーブル

| Column             | Type     | Options                                             |
| ------------------ | -------- | --------------------------------------------------- |
| first_name         | string   | null: false                                         |
| last_name          | string   | null: false                                         |
| email              | string   | null: false, unique: true                           |
| encrypted_password | string   | null: false                                         |
| role               | integer  | null: false, default: 0 (0=patient, 1=supporter)    |
| deleted_at         | datetime |                                                     |
| created_at         | datetime | null: false                                         |
| updated_at         | datetime | null: false                                         |

### Association
- has_one  :invite_code (supporter only)
- has_many :support_links_as_supporter, class_name: "SupportLink", foreign_key: "supporter_id", dependent: :destroy
- has_many :patients, through: :support_links_as_supporter, source: :patient
- has_many :support_links_as_patient, class_name: "SupportLink", foreign_key: "patient_id", dependent: :destroy
- has_many :supporters, through: :support_links_as_patient, source: :supporter
- has_many :meal_records, foreign_key: "patient_id", dependent: :destroy
- has_many :comments_as_supporter, class_name: "Comment", foreign_key: "supporter_id", dependent: :destroy

---

## invite_codes テーブル

| Column       | Type     | Options                               |
| ------------ | -------- | ------------------------------------- |
| supporter_id | bigint   | null: false, FK → users.id            |
| code         | string   | null: false, unique: true             |
| created_at   | datetime | null: false                           |
| updated_at   | datetime | null: false                           |

### Association
- belongs_to :supporter, class_name: "User"

---

## support_links テーブル

| Column       | Type     | Options                               |
| ------------ | -------- | ------------------------------------- |
| supporter_id | bigint   | null: false, FK → users.id            |
| patient_id   | bigint   | null: false, FK → users.id            |
| created_at   | datetime | null: false                           |
| updated_at   | datetime | null: false                           |

### Association
- belongs_to :supporter, class_name: "User"
- belongs_to :patient, class_name: "User"

---

## meal_records テーブル

| Column     | Type     | Options                                |
| ---------- | -------- | -------------------------------------- |
| patient_id | bigint   | null: false, FK → users.id             |
| eaten_on   | date     | null: false                            |
| slot       | integer  | null: false (0=朝/1=昼/2=夕/3=間食)     |
| text       | text     |                                        |
| note       | text     |                                        |
| created_at | datetime | null: false                            |
| updated_at | datetime | null: false                            |

### Association
- belongs_to :patient, class_name: "User"
- has_one_attached :photo
- has_many :comments, dependent: :destroy

---

## comments テーブル

| Column        | Type     | Options                               |
| ------------- | -------- | ------------------------------------- |
| meal_record_id| bigint   | null: false, FK → meal_records.id     |
| supporter_id  | bigint   | null: false, FK → users.id            |
| body          | text     | null: false                           |
| read          | boolean  | null: false, default: false           |
| created_at    | datetime | null: false                           |
| updated_at    | datetime | null: false                           |

### Association
- belongs_to :meal_record
- belongs_to :supporter, class_name: "User"