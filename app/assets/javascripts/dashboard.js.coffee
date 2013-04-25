# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  if $('#activities').length
    new ActivityPager()

class ActivityPager
  constructor: (@page = 1) ->
    $(window).scroll(@check)

  check: =>
    if @nearBottom()
      @page++
      $(window).unbind('scroll', @check)
      $.getJSON($('#activities').data('json-url'), page: @page, @render)

  nearBottom: =>
    $(window).scrollTop() > $(document).height() - $(window).height() - 50

  render: (activities) =>
    for activity in activities
      $('#activities').append Mustache.to_html($('#activity_template').html(), activity)
    $(window).scroll(@check) if activities.length > 0