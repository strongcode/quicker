jQuery("*[data-type='anchor']").livequery('click', function (event) {
    window.location = $(this).attr('data-href')
});

jQuery("*[data-type='submit']").livequery('click', function (event) {
    document.forms[0].submit();
});


// image radio button logic
jQuery(document).ready(function () {
    $("*[data-radio-button-image='true']").css('cursor', 'pointer')
    $("img[data-selected='true']").attr('src', '/assets/' + $("img[data-selected='true']").attr('data-enabled-image-path'))
});

jQuery("*[data-radio-button-image='true']").livequery('click', function (event) {
    $("*[data-radio-button-image='true']").each(function (index) {
        $(this).attr('src', '/assets/' + $(this).attr('data-disabled-image-path'))
    });

    $(this).attr('src', '/assets/' + $(this).attr('data-enabled-image-path'))
    $($(this).next('input[type="radio"]')[0]).attr('checked', 'checked')

});
// end of image radio button logic

jQuery(document).ready(function () {
    $("#new_goal").validate({ignore: ''})

    $(".fancy-box-link").fancybox({
    });

    $(".fancy-box-iframe").fancybox({
        'width':'75%',
        'height':'75%',
        'autoScale':false,
        'transitionIn':'none',
        'transitionOut':'none',
        'type':'iframe'
    });
    $(".fancy-box-image").fancybox({
        'autoScale':false,
        'transitionIn':'none',
        'transitionOut':'none'
    });

});

$(".file_alternate_element").livequery('click', function (event) {
    $(this).next('div').children('input[type="file"]').click();
});

$('.edit_goal input[type="file"]').livequery('change', function (event) {
    $(this).parents('form').submit();
});

//Ajax
$.ajaxSetup({
    cache: false,
    'beforeSend': function(xhr) {
        xhr.setRequestHeader("Accept", "");
        xhr.setRequestHeader("Accept", "text/javascript")
    }
});

// Global ajax activity indicators.
$(document).ajaxStart(
    function() {
        $('#ajax-indicator').show();

    }).ajaxStop(function() {
        $('#ajax-indicator').hide();

    });