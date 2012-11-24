$ ->
  $('.person-status').click ->
    details = $('#person-details')
    return if details.css('display') != 'none'
    title = details.attr('data-article-title')
    $.ajax
      url: '/details',
      type: 'GET',
      dataType: 'html',
      data: { article_title: title }
      success: (data, status, xhr) ->
        updateDetails(data)
    return false

updateDetails = (data) ->
  $('#person-details').prepend(data).slideDown("slow")
