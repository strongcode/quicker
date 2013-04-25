module OffersHelper

  def snap_or_learn_more(offer)
    if offer.offer_options.present?
      link_to  "Snap It Up", track_snapped_insider_offer_path(offer), :class => 'btn1 snap_it_btn btn-info bold', :target => '_blank'
    else
      link_to "Learn More", offer.deal_url, :class => 'btn1 snap_it_btn btn-info bold', :target => '_blank'
    end
  end
  
end
