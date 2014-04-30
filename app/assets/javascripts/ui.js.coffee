class Bte.UI
  render: ->
    $('.carousel').carousel({ interval: 1000 })
    $('#student_sign_up').hide()
    $('#teacher_sign_up').hide()

    $(document)
      .on('click', '#teacher_sign_up_link',    @showTrainerModal)
      .on('click', '#student_sign_up_link',    @showStudentModal)
      .on('click', '#teacher_modal_close_button', @hideTrainerForm)
      .on('click', '#student_modal_close_button', @hideStudentModal)
      .on('click', '#teacher_close_icon_modal', @hideTrainerForm)
      .on('click', '#student_close_icon_modal', @hideStudentModal)

  showTrainerModal: (event)->
    event.preventDefault()
    $('#teacher_sign_up').toggle(1000)

  showStudentModal: (event)->
    event.preventDefault()
    $('#student_sign_up').toggle(1000)

  hideTrainerForm: (event)->
    $('#teacher_sign_up').hide()

  hideStudentModal: (event)->
    $("#student_sign_up").hide()