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



updateCurrentPick = (currentPick) ->
  pick = $('.current-pick')
  pick.find('.decimal').text currentPick.decimal
  pick.find('.owner').text currentPick.owner
  return

updateSideBar = (currentPick) ->
  list = $('.sidebar .draft-order')
  button = list.find("[data-pick-decimal='" + currentPick.decimal + "']")
  button.html("<span class=\"pick-number\">" + currentPick.decimal + "</span>" + currentPick.player + "<span class=\"owner\">" + currentPick.owner + "</span>")
  button.toggleClass('unselected').toggleClass('selected').toggleClass('disabled').toggleClass('current')
  # $('.sidebar').scrollTop
  b = button.prev('button').prev('button').prev('button').prev('button').prev('button').prev('button').get(0)
  if b
    b.scrollIntoView()
  nextInDOM('button.unselected', button).toggleClass('current')
  return

initialScroll = () ->
  button = $('.sidebar .draft-order .current')
  b = button.prev('button').prev('button').prev('button').prev('button').prev('button').prev('button').get(0)
  if b
    b.scrollIntoView()
  return


ready = ->
  initialScroll()
  $('.player.unpicked').click ->
    $this = $(this)
    player = player: id: $(this).data('player')
    $.post('/pick.json', player).done((data) ->
      console.log 'Successfully picked'
      $this.toggleClass('picked').toggleClass 'unpicked'
      ownerTD = $this.find('td.owner')
      if ownerTD
        ownerTD.text(data.current_pick.owner)
      updateCurrentPick data.next_pick
      updateSideBar data.current_pick
      $this.off('click')
      return
    ).fail (error) ->
      console.log 'Error picking'
      console.log error
      return
    return
  return

$(document).ready(ready)
$(document).on('page:load', ready)