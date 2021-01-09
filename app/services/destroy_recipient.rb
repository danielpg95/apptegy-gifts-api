# As action complexity starts to grow, new actions or services are implemented inside the call method,
# granting great flexibility for new features implementation
class DestroyRecipient
  def initialize(params)
    @params = params
    school = School.find_by(id: @params[:school_id])
    @recipient = school.recipients.find_by(id: @params[:id])
  end

  def call
    @recipient.update(enabled: false)
  end
end