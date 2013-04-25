module SuggestionsHelper

  def get_suggestion_title(suggestion)
    if suggestion.present?
      title = "#{suggestion.name} - #{suggestion.location.city}"
    end
    if current_user.friends.map(&:friend_id).include?(suggestion.user_id)
      title += " - Suggested by #{suggestion.user.full_name}"
    end
    title
  end

  def get_suggestion_categories(suggestion, categories)
    if suggestion.present? && !suggestion.new_record?
      categories.collect {|category| [category.description, category.id] }
    else
      [[Category.get_lifestyle_category.description, Category.get_lifestyle_category.id]] + categories.collect {|category| [category.description, category.id] }
    end
  end

  def get_selected_option(category)
    category.present? ? (category.major_category.downcase): ('')
  end
end
