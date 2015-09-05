nextInDOM = (_selector, _subject) ->
  next = getNext(_subject)
  while next.length != 0
    found = searchFor(_selector, next)
    if found != null
      return found
    next = getNext(next)
  null

getNext = (_subject) ->
  if _subject.next().length > 0
    return _subject.next()
  getNext _subject.parent()

searchFor = (_selector, _subject) ->
  if _subject.is(_selector)
    return _subject
  else
    found = null
    _subject.children().each ->
      found = searchFor(_selector, $(this))
      if found != null
        return false
      return
    return found
  null
  # will/should never get here

confirmLeagueDeletion = (link) ->
  href = link.attr('href')
  name = link.data('name')
  $row = link.closest('tr')
  swal {
    title: 'Are you sure you want to delete ' + name + '?'
    text: 'You will lose all of this league\'s teams and draft picks!'
    type: 'warning'
    showCancelButton: true
    confirmButtonColor: '#DD6B55'
    confirmButtonText: 'Yes, delete it!'
    cancelButtonText: 'No'
    closeOnConfirm: false
    showLoaderOnConfirm: true
  }, (isConfirm) ->
    if isConfirm
      $.post(href + '.json', { _method: 'delete' }, null, 'script').done((data) ->
        swal {
          title: 'Deleted ' + name + '!'
          type: 'success'
          confirmButtonColor: '#286090'
          allowOutsideClick: true
        }
        $body = $row.parent()
        $row.remove()
        if $body.find('tr').length == 0
          $body.parent('.table')
            .hide().after('<p class="no-leagues">Please create a league to get started.</p>')
        

        false
      ).fail (error) ->
        swal 'Oops...', 'Something went wrong. Could not delete the league :(', 'error'
        false
    else
      return false
    return

getLeague = () ->
  return $('body').data('league')

pickPlayer = (button) ->
  $this = $(button)
  if $this.hasClass('limited')
    return
  
  player = player: id: $this.data('player')
  $.post('/l/' + getLeague() + '/pick.json', player).done((data) ->
    console.log 'Successfully picked'
    showAlert('alert-info', data.current_pick.owner + ' picked ' + data.current_pick.player)
    $this.addClass('picked').removeClass 'unpicked'
    ownerTD = $this.find('td.owner')
    if ownerTD
      ownerTD.text(data.current_pick.owner)
    updateCurrentPick data.next_pick
    updateSideBar data.current_pick
    updateLimitedPositions(data.limited_positions)
    showUndo()
    $this.off('click')
    return
  ).fail (error) ->
    console.log 'Error picking'
    console.log error.responseJSON
    message = "Error: could not complete pick."
    if error.responseJSON
      word = Object.keys(error.responseJSON)[0]
      message += " " + word.charAt(0).toUpperCase() + word.slice(1);
      message += " " + error.responseJSON[word]

    showAlert('alert-danger', message)
    return
  return

updateCurrentPick = (currentPick) ->
  pick = $('.current-pick')
  pick.find('.decimal').text currentPick.decimal
  pick.find('.owner').text currentPick.owner
  pick.find('.picks-left').text currentPick.picks_left
  return

updateSideBar = (currentPick) ->
  list = $('.sidebar .draft-order')
  button = list.find("[data-pick-decimal='" + currentPick.decimal + "']")
  button.html("<span class=\"pick-number\">" + currentPick.decimal + "</span>" + currentPick.player + "<span class=\"owner\">" + currentPick.owner + "</span>")
  button.removeClass('unselected').addClass('selected').addClass('disabled').removeClass('current')
  # $('.sidebar').scrollTop
  b = button.prev('button').prev('button').prev('button').prev('button').prev('button').prev('button').get(0)
  if b
    b.scrollIntoView()
  nextInDOM('button.unselected', button).toggleClass('current')
  return

undoSideBar = (currentPick) ->
  list = $('.sidebar .draft-order')
  list.find('.list-group-item.current').removeClass('current')
  button = list.find("[data-pick-decimal='" + currentPick.decimal + "']")
  button.html("<span class=\"pick-number\">" + currentPick.decimal + "</span>" + currentPick.owner)
  button.addClass('unselected').removeClass('selected').removeClass('disabled').addClass('current')
  b = button.prev('button').prev('button').prev('button').prev('button').prev('button').prev('button').get(0)
  if b
    b.scrollIntoView()
  return

initialScroll = () ->
  button = $('.sidebar .draft-order .current')
  b = button.prev('button').prev('button').prev('button').prev('button').prev('button').prev('button').get(0)
  if b
    b.scrollIntoView()
  return

fadeOutAlert = () ->
  alert = $('.content .alert:first')
  setTimeout (->
    alert.fadeOut(1000)
    return
  ), 8000
  return

showAlert = (type, message) ->
  $('.content .alert').hide()
  $('<div class="alert ' + type + '" style="display: none;">' + 
    '<button class="close" data-dismiss="alert">x</button>' +
    message + '</div>').prependTo('.content').fadeIn(500)
  fadeOutAlert()
  return

showUndo = () ->
  $('.navbar .undo').show();
  return

hideUndo = (currentPick) ->
  if currentPick.decimal == '1.1'
    $('.navbar .undo').hide();
  return

updateTeamPageOnUndo = (html) ->
  if html && $('.fantasy-teams').length >= 1
    tbody = $('.picks-table').html(html.picks)
    tbody = $('.roster-table').html(html.roster)
  
  return

updateLimitedPositions = (positions) ->
  $('.player.limited').removeClass('limited')
  positions.forEach (pos) ->
    $('.player.' + pos.toLowerCase()).addClass 'limited'
    return

postUndoForm = () ->
  $.post('/l/' + getLeague() + '/pick/undo.json').done((data) ->
    console.log('Successful undo')
    showAlert('alert-success', data.message)
    tag = $(".content").find("[data-player='" + data.prev_pick.player_id + "']")
    if $('.draft').length >= 1 # on the draft board
      tag.replaceWith('<td></td>')
    else # on a picking board
      tag.removeClass('picked').addClass('unpicked')
      tag.click ->
        pickPlayer(this)
        return

    # check if on the fantasy team's page with the undone pick
    updateTeamPageOnUndo(data.html)

    ownerTD = tag.find('td.owner')
    if ownerTD
      ownerTD.text('')

    updateCurrentPick data.prev_pick
    undoSideBar data.prev_pick
    updateLimitedPositions(data.limited_positions)
    hideUndo(data.prev_pick)
    return
  ).fail (error) ->
    console.log('Failed to undo')
    showAlert('alert-danger', error.responseText)
    return
  return



ready = ->
  initialScroll()
  fadeOutAlert()
  $('.player.unpicked').click ->
    pickPlayer(this)
    return

  $('#undo-form').submit ->
    postUndoForm()
    return false

  $('.leagues.index a.delete').click (e) ->
    e.preventDefault()
    confirmLeagueDeletion($(this))
    return

  return

$(document).ready(ready)
$(document).on('page:load', ready)

Turbolinks.pagesCached(0);