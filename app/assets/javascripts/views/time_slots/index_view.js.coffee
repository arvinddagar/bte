class Bte.Views.TimeSlots.IndexView
  render: =>
    $(document)
      .on('click', 'input.cancel', @cancelSlot)
      .on('click', 'input.save', @AddSlot)
      .on('click', 'a.add-time-slot', @HideTimeSlot)

  cancelSlot: (event)=>
    event.preventDefault()
    $('.time-slot-form').hide()
    $('a.add-time-slot').show()

  AddSlot: (event)=>
    event.preventDefault()
    $('.time-slot-form').hide()
    $(this).parents('td:first').find('.loading').show()

  HideTimeSlot: (event)=>
    event.preventDefault()
    $('.time-slot-form').hide()
    $('a.add-time-slot').show()
    $(this).hide()
    $(this).prev().show()