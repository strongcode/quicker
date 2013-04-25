class DealSite < ActiveRecord::Base

  attr_accessible  :name, :url, :deal_site_params, :deal_site_key, :deal_site_status, :frequency, :last_datetime_run
  
end
