class ContactsController < ApplicationController
  def new
    @contact=Contact.new
  end
  def create
    @contact=Contact.new(params[:contact])
    if @contact.save
      Notifier.contact(@contact).deliver
      if user_signed_in?
        redirect_to current_user.default_landing_page
      else
        redirect_to root_url
      end
    else
      render contact_us_url
    end
  end
end
