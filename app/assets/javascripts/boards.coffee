# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

updateCurrentPick = (currentPick) ->
  pick = $('.current-pick')
  pick.find('.decimal').text currentPick.decimal
  pick.find('.owner').text currentPick.owner
  return

updateSideBar = (currentPick) ->
  list = $('.sidebar .draft-order')
  button = list.find("[data-pick-decimal='" + currentPick.decimal + "']")
  button.html("<span class=\"pick-number\">" + currentPick.decimal + "</span>" + currentPick.player + "<span class=\"owner\">" + currentPick.owner + "</span>")
  button.toggleClass('unselected').toggleClass('selected').toggleClass('disabled')
  # $('.sidebar').scrollTop
  button.prev('button').prev('button').prev('button').prev('button').prev('button').prev('button').get(0).scrollIntoView()
  return


ready = ->
  $('.player.unpicked').click ->
    $this = $(this)
    player = player: id: $(this).data('player')
    $.post('/pick.json', player).done((data) ->
      console.log 'Successfully picked'
      $this.toggleClass('picked').toggleClass 'unpicked'
      updateCurrentPick data.next_pick
      updateSideBar data.current_pick
      return
    ).fail (error) ->
      console.log 'Error picking'
      console.log error
      return
    return
  return

$(document).ready(ready)
$(document).on('page:load', ready)