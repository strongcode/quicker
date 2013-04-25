class User < ActiveRecord::Base

  module OmniauthCallbacks
    def find_or_create_for_facebook response
      logger.debug "*********"
      logger.debug response.inspect
      logger.debug "*********"
      user = User.find_by_source_id(response['uid'])
      unless user
        status = true
        user = User.new(:source => 'facebook',
          :source_id => response['uid'],
          :password => Devise.friendly_token[0, 20],
          :email => response['info']['email'].presence || response['extra']['raw_info']['email'].presence || "dummy@gmail.com",
          :name => response['info']['nickname'],
          :first_name => response['info']['first_name'],
          :last_name => response['info']['last_name']
        )
        user.save(:validate => false)
        user_profile = user.build_user_profile(:gender => response['extra']['raw_info']['gender'],
          :picture => response['info']['image'],
          :locale => response['extra']['raw_info']['locale'],
          :first_name => response['info']['first_name'],
          :last_name => response['info']['last_name'],
          :relationship_status => response['extra']['relationship_status'],
          :timezone => response['extra']['raw_info']['timezone'],
          :location_city => response['extra']['raw_info']['location'].present? ? (response['extra']['raw_info']['location']['name']) : (''),
          :date_of_birth => response['extra']['raw_info']['birthday'],
          :interests => response['extra']['raw_info']['interested_in']
        )
        user_profile.adv_pref_flag = 1
        user_profile.customize_avatars = 1
        user_profile.category_flag = 1
        
        user_profile.save!
        user_profile.set_language
      else
        status = false
      end
      return user, status
    end

    def find_or_create_for_twitter response
      user = User.find_by_source_id(response['uid'])
      unless user
        status = true
        user = User.new(:source => 'twitter',
          :source_id => response['uid'],
          :password => Devise.friendly_token[0, 20],
          :name => response['info']['name']
        )
        if user.save(:validate => false)
          user_profile = user.build_user_profile(
            :picture => response['info']['image'],
            :locale => response['extra']['raw_info']['lang'],
            :description => response['info']['image'],
            :timezone => response['extra']['raw_info']['time_zone'],
            :followers_count => response['extra']['raw_info']['followers_count'],
            :friends_count => response['extra']['raw_info']['friends_count']
          )
          user_profile.set_language
          user.id_str = user.id
          user.save
        end
      else
        status = false
      end
      return user, status
    end

    def find_or_create_for_linkedin response
      user = User.find_by_source_id(response['uid'])
      unless user
        status = true
        user = User.new(:source => 'linkedin',
          :source_id => response['uid'],
          :password => Devise.friendly_token[0, 20],
          :email => response['info']['email'],
          :name => response['info']['name'],
          :first_name => response['info']['first_name'],
          :last_name => response['info']['last_name']
        )

        if user.save(:validate => false)
          user_profile = user.build_user_profile(:gender => '',
            :picture => response['info']['image'],
            :location_city => response['extra']['raw_info']['location']['name'],
            :country => response['extra']['raw_info']['location']['code']
          )
          user_profile.set_language
          user_profile.save
        end
      else
        status = false
      end
      return user, status
    end

    def find_or_create_for_google_oauth2 response
      user = User.find_by_source_id(response['uid'])
      unless user
        status = true
        user = User.new(:source => 'google_oauth2',
          :source_id => response['uid'],
          :password => Devise.friendly_token[0, 20],
          :email => response['info']['email'],
          :name => response['info']['name'],
          :first_name => response['info']['first_name'],
          :last_name => response['info']['last_name']
        )

        if user.save(:validate => false)
          user_profile = user.build_user_profile(
            :gender => response['extra']['raw_info']['gender'],
            :picture => response['info']['image'],
            :locale => response['extra']['raw_info']['locale']
          )
          user_profile.set_language
          user_profile.save
        end
      else
        status = false
      end
      return user, status
    end

  end
end
