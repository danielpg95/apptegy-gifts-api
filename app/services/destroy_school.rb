# As action complexity starts to grow, new actions or services are implemented inside the call method,
# granting great flexibility for new feautes implementation
class DestroySchool
  def initialize(params)
    @params = params
    @school = School.find_by(id: @params[:id])
  end

  def call
    # Validations were made in the controller action validator
    @school.destroy
  end
end