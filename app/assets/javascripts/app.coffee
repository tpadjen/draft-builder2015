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

pickPlayer = (button) ->
  $this = $(button)
  player = player: id: $this.data('player')
  $.post('/pick.json', player).done((data) ->
    console.log 'Successfully picked'
    showAlert('alert-info', data.current_pick.owner + ' picked ' + data.current_pick.player)
    $this.addClass('picked').removeClass 'unpicked'
    ownerTD = $this.find('td.owner')
    if ownerTD
      ownerTD.text(data.current_pick.owner)
    updateCurrentPick data.next_pick
    updateSideBar data.current_pick
    showUndo()
    $this.off('click')
    return
  ).fail (error) ->
    showAlert('alert-danger', "Error: could not complete pick.")
    console.log 'Error picking'
    console.log error
    return
  return

updateCurrentPick = (currentPick) ->
  pick = $('.current-pick')
  pick.find('.decimal').text currentPick.decimal
  pick.find('.owner').text currentPick.owner
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

postUndoForm = () ->
  $.post('/pick/undo.json').done((data) ->
    console.log('Successful undo')
    console.log(data)
    showAlert('alert-success', data.message)
    tag = $(".content").find("[data-player='" + data.prev_pick.player_id + "']")
    console.log(tag)
    tag.removeClass('picked').addClass('unpicked')
    tag.click ->
      pickPlayer(this)
      return

    ownerTD = tag.find('td.owner')
    if ownerTD
      ownerTD.text('')

    updateCurrentPick data.prev_pick
    undoSideBar data.prev_pick
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
  return

$(document).ready(ready)
$(document).on('page:load', ready)