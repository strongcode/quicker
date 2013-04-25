class Notifier < ActionMailer::Base
  default :from => configatron.notifier.from

  def request_intimation(email)
    mail(:to => email, :subject => 'SnapGadget Invite Request')
  end

  def adminstrator(email, ip, city, region_name)
    @content = "#{email}, #{ip}, #{city}, #{region_name}"
    mail(:to => configatron.snapgadget.admin, :subject => @content ) do |format|
      format.text { render :text => @content }
    end
  end

  def test
    mail(:to => ['sadiga@qwinixtech.com', 'sukeerthiadiga@gmail.com'], :subject => @content) do |format|
      format.text { render :text => 'hello' }
    end
  end

  def contact contact
    @contact = contact
    message = "#{@contact.message}\n#{@contact.first_name}  #{@contact.last_name}  #{@contact.email} "
    mail(:from =>['contactus@snapgadget.com'],:to => ['contactus@snapgadget.com'],
      :subject => "Contact Us from #{@contact.email} - #{@contact.message.first(20)}")do |format|
      format.text { render :text => message}
    end
  end

  def advertise advertise
    @advertise = advertise
    message = "#{@advertise.message}\n#{@advertise.first_name}  #{@advertise.last_name}  #{@advertise.email} "
    mail(:from => ['advertize@snapgadget.com'],:to => ['advertize@snapgadget.com'],
      :subject => "Advertise from #{@advertise.email} - #{@advertise.message.first(20)}")do |format|
      format.text { render :text => message}
    end
  end

  def update_password (profile_user,ip)
    @profile_user = profile_user
    message="You recently changed your password on SnapGadget.com from #{ip} "
    mail(:from =>['PasswordChange@snapgadget.com'], :to => @profile_user.email,
      :subject => "You changed your SnapGadget password") do |format|
      format.text { render :text => message}
    end
  end
end
