$(document).ready ->
    populateFooter()

populateFooter = ->
    $.ajax
        url: '/page_views/recent',
        type: 'GET',
        dataType: 'json',
        success: (data, status, xhr) ->
            populateTable(data)

populateTable = (data) ->
    table = $("#recents")
    page_views = data['page-views'].reverse()
    for page_view in page_views
        addHistoryEntry(table, page_view)
    window.setTimeout requestRecents, 10000
    return true

addHistoryEntry = (table, page_view) ->
    table.prepend "
        <tr page-view-id='#{page_view['page-view-id']}' style='background-color:#{page_view['color']};'>
            <td><a href='/show/#{page_view['record']}'>#{page_view['name']}'</a></td>
        </tr>"

requestRecents = ->
    lastPageViewId = $('#recents tr:first').attr('page-view-id')
    if lastPageViewId
        $.ajax
            url: '/page_views/since',
            type: 'GET',
            dataType: 'json',
            data: { 'id': lastPageViewId }
            success: (data, status, xhr) ->
                updateRecents(data)

updateRecents = (data) ->
    numEntries = data['page-views'].length
    table = $('#recents')
    if numEntries > 0
        $('#recents tr:last').remove() for[1..numEntries]
        page_views = data['page-views'].reverse()
        for page_view in page_views
            addHistoryEntry(table, page_view)
    window.setTimeout requestRecents, 10000
    return true
