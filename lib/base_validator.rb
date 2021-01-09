# Validator that contains shared methods between validators.
class BaseValidator
  # This adds the ability to use model validations inside our action validators
  include ActiveModel::Model
  include ActiveModel::Validations::Callbacks

  def t(key_path)
    I18n.t("activemodel.errors.models.#{key_path}")
  end

  def validation_errors
    { errors: self.errors }
  end
end