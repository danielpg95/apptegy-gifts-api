# As action complexity starts to grow, new actions or services are implemented inside the call method,
# granting great flexibility for new feautes implementation
class CreateRecipient
  def initialize(params)
    @params = params
  end

  def call
    # Validations were made in the controller action validator
    Recipient.create(@params)
  end
end