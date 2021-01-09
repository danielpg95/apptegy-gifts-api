# As action complexity starts to grow, new actions or services are implemented inside the call method,
# granting great flexibility for new features implementation
class UpdateRecipient
  def initialize(params)
    @params = params
    school = School.find_by(id: @params[:school_id])
    @recipient = school.recipients.find_by(id: @params[:id], enabled: true)
  end

  def call
    # Validations were made in the controller action validator
    @recipient.update(update_params)
    @recipient.reload
  end

  private

  def update_params
    @params.except(:id)
  end
end