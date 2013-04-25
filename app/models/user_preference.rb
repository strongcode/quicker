class UserPreference < ActiveRecord::Base
  attr_accessible :user_id, :landing_page_id, :offer_category_1, :offer_category_2, :offer_category_3,
    :suggestion_category_1, :suggestion_category_2, :suggestion_category_3, :you_deserve_it_category,
    :repeat_experiences, :shopping_on_sidekick, :food_on_sidekick, :travel_on_sidekick,
    :lifestyle_on_sidekick, :business_on_sidekick, :friends_on_sidekick,
    :question_1, :question_2, :question_3, :question_4, :question_5

  belongs_to :user

  #validate :check_for_category_suggestion_and_deserve_it

  validate :offer_category_1, :uniqueness => {:scope => [:offer_category_2, :offer_category_3, :suggestion_category_1, :suggestion_category_2, :suggestion_category_3, :you_deserve_it_category]}

  def assistant_icon
    page = SgPage.find_by_id self.landing_page_id
    (page.present? && page.name =~ /assistant/i) ? ("assistant_normal") : ("assistant_disabled")
  end

  def insider_icon
    page = SgPage.find_by_id self.landing_page_id
    (page.present? && page.name =~ /insider/i) ? ("insider_normal") : ("insider_disabled")
  end

  def sidekick_icon
    page = SgPage.find_by_id self.landing_page_id
    logger.debug "*****"
    logger.debug self.landing_page_id
    logger.debug "*****"
    (page.present? && page.name =~ /sidekick/i) ? ("sidekick_normal") : ("sidekick_disabled")
  end

  def offer_category_first
    Category.find_by_id self.offer_category_1
  end

  def offer_category_second
    Category.find_by_id self.offer_category_2
  end

  def offer_category_third
    Category.find_by_id self.offer_category_3
  end

  def suggestion_category_first
    Category.find_by_id self.suggestion_category_1
  end

  def suggestion_category_second
    Category.find_by_id self.suggestion_category_2
  end

  def suggestion_category_third
    Category.find_by_id self.suggestion_category_3
  end

  def deserve_it
    Category.find_by_id self.you_deserve_it_category
  end

  def check_for_category_suggestion_and_deserve_it
    #unless  offer_category_1 || offer_category_2 || offer_category_3
    # errors.add(:base, "Please select at least one Category")
    #end

    #unless  suggestion_category_1 || suggestion_category_2 || suggestion_category_3
    # errors.add(:base, "Please select at least one Suggestion")
    #end

    #    unless  you_deserve_it_category
    #     errors.add(:base, "Please select Deserve it")
    #  end
  end

  def get_default_landing_page
    self.landing_page_id = SgPage.find_by_name('sidekick').try(&:id)
  end

  def visit_or_revisit
    (self.question_1.present? || self.question_2.present?) ? (I18n.t(:revisit)) : (I18n.t(:visit))
  end

  def populate_questions(slider1, slider2, slider3, order1, order2, order3)
    str1 = ''
    str2 = ''
    slider1.present? ? (str1 = str1 + "#{slider1},") : ()
    slider2.present? ? (str1 = str1 + "#{slider2},") : ()
    slider3.present? ? (str1 = str1 + "#{slider3}") : ()
    self.question_1 = str1

    order1.present? ? (str2 = str2 + "#{order1},") : ()
    order2.present? ? (str2 = str2 + "#{order2},") : ()
    order3.present? ? (str2 = str2 + "#{order3}") : ()
    self.question_2 = str2
  end

  def get_class(type)
    case type
    when /lifestyle/i
      self.lifestyle_on_sidekick ? ("lifestyle_active") : ("lifestyle_disable")
    when /food/i
      self.food_on_sidekick ? ("food_active") : ("food_disable")
    when /shopping/i
      self.shopping_on_sidekick ? ("shopping_active") : ("shopping_disable")
    when /business/i
      self.business_on_sidekick ? ("business_active") : ("business_disable")
    when /friends/i
      self.friends_on_sidekick ? ("friends_active") : ("friends_disable")
    when /travel/i
      self.travel_on_sidekick ? ("travel_active") : ("travel_disable")
    else

    end
  end

  class << self
    def pref_completeness(user)
      percentage = 0
      prefs = self.select("question_1, question_2, question_3, question_4, question_5").where(:user_id => user.id)
      prefs.each do |pref|
        percentage = percentage + (pref.question_1 == '0,0,0' || pref.question_1.blank?  ? (0) : (20))
        percentage = percentage + (pref.question_2.present? ? (20) : (0))
        percentage = percentage + (pref.question_3 == '0' || pref.question_3.blank? ?  (0) : (20))
        percentage = percentage + (pref.question_4 == '0' || pref.question_4.blank? ?  (0) : (20))
        percentage = percentage + (pref.question_5 == '0' || pref.question_5.blank? ?  (0) : (20))
      end
      percentage
    end
  end

end
