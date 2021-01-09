# As action complexity starts to grow, new actions or services are implemented inside the call method,
# granting great flexibility for new feautes implementation
class UpdateSchool
  def initialize(params)
    @params = params
    @school = School.find_by(id: @params[:id])
  end

  def call
    # Validations were made in the controller action validator
    @school.update(update_params)
    @school.reload
  end

  private

  def update_params
    @params.except(:id)
  end
end