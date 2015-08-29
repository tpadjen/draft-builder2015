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
  button.next('button.unselected').toggleClass('current')
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