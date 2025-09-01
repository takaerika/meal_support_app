class Supporter::HomeController < Supporter::BaseController
  def index
    sort  = params[:sort].presence || "recent"
    scope = current_user.patients.alive

    @patients =
      case sort
      when "name"
        scope.order(
          Arel.sql("CASE WHEN users.last_name_kana IS NULL OR users.last_name_kana = '' THEN 1 ELSE 0 END ASC"),
          :last_name_kana, :first_name_kana, :last_name, :first_name
        )
      when "recent"
        scope
          .left_joins(:meal_records)
          .select('users.*, MAX(meal_records.updated_at) AS max_meal_updated_at')
          .group('users.id')
          .order(Arel.sql('COALESCE(users.last_meal_updated_at, MAX(meal_records.updated_at)) IS NULL, COALESCE(users.last_meal_updated_at, MAX(meal_records.updated_at)) DESC'))
      else
        scope.order(:last_name, :first_name)
      end

    patient_ids = @patients.map(&:id)

    raw = Comment.joins(:meal_record)
                 .where(meal_records: { patient_id: patient_ids })
                 .select('comments.*, meal_records.patient_id AS patient_id')
                 .order('comments.created_at DESC')

    @latest_comments_by_patient = {}
    raw.each do |c|
      pid = c.read_attribute(:patient_id)
      @latest_comments_by_patient[pid] ||= c
      break if @latest_comments_by_patient.size == patient_ids.size
    end
  end
end