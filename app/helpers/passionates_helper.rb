module PassionatesHelper

  def get_passionate_location(passionate)
    passionate.present? && passionate.location.present? ? (passionate.location.name) : ("")
  end

  def passionate_caption
    current_user.passionate.present? ? (t('dashboard.your_passionate')) : t('dashboard.your_new_passionate')
  end
end
