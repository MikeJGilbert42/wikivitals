$(document).ready ->
    populateFooter()

populateFooter = ->
    $.ajax
        url: '/page_views/recent',
        type: 'GET',
        dataType: 'json',
        success: (data, status, xhr) ->
            doStuff(data)


doStuff = (data) ->
    for page_view in data["page-views"]
        $("#recents").append "
        <tr page-view-id='#{page_view['page-view-id']}' style='background-color:#{page_view['color']};'>
            <td><a href='/show/#{page_view['record']}'>#{page_view['name']}'</a></td>
        </tr>"
    return true