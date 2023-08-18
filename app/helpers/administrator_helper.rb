module AdministratorHelper
  def previews_color(value)
    return '' if value.nil?

    value == 'enabled' ? 'text-green-700 bg-green-100' : 'text-red-700 bg-red-100'
  end
end
