class Bte.CurrentUser
  constructor: (data={})->
    @type     = data.type

    switch @type
      when "student" then @signInStudent()
      when "tutor" then @signInTutor()

  signInStudent: =>


  signInTutor: =>

    $(document)
  #     .on('click', '#join_tutoring_session_modal .accept', @accept)
  #     .on('click', '#join_tutoring_session_modal .decline', @decline)

  #   @goOnline() if @status == "online"

  # accept: (event)=>
  #   button = $(event.currentTarget)
  #   button.attr('disabled', true)
  #   button.text(button.data('disable-with'))
  #   @channel.trigger('client-tutor-accepted-invitation', @currentInvitation)

  # decline: (event)=>
  #   @channel.trigger('client-tutor-declined-invitation', @currentInvitation)
  #   @hidePrompt()

  # toggleOnlineOffline: (event,data)=>
  #   if data.value then @goOnlineLink.click() else @goOfflineLink.click()

  # goOnline: (event)=>
  #   event.preventDefault() if event?
  #   $('.app-menu-user .status-badge').addClass('online')
  #   @dropdown.dropdown('toggle') if @dropdown.parent().hasClass('open')
  #   @goOnlineLink.addClass('hidden')
  #   @goOfflineLink.removeClass('hidden')
  #   @onlineOfflineToggle.bootstrapSwitch?('setState', true)
  #   Bte.pusher().subscribe("presence-tutors-#{@desiredLanguage}")
  #   @channel = Bte.pusher().subscribe("private-tutor-#{@tutorId}")
  #     .bind('client-student-invited-tutoring-session', @promptToJoinTutoringSession)
  #     .bind('client-student-canceled-invitation', @hidePrompt)
  #     .bind('student-created-tutoring-session', @joinSession)

  # goOffline: (event)=>
  #   event.preventDefault() if event?
  #   $('.app-menu-user .status-badge').removeClass('online')
  #   @goOfflineLink.addClass('hidden')
  #   @goOnlineLink.removeClass('hidden')
  #   @dropdown.dropdown('toggle') if @dropdown.parent().hasClass('open')
  #   @onlineOfflineToggle.bootstrapSwitch?('setState', false)
  #   Bte.pusher().unsubscribe("presence-tutors-#{@desiredLanguage}")
  #   Bte.pusher().unsubscribe("private-tutor-#{@tutorId}")

  # promptToJoinTutoringSession: (data)=>
  #   @currentInvitation = data
  #   @joinSessionModal.find('.student-name').text(data.name)
  #   @joinSessionModal.find('.language').text(data.language)
  #   @joinSessionModal.find('.country').text(data.country)
  #   @joinSessionModal.find('.Bte-rating').text(data.BteRating)
  #   @joinSessionModal.find('.learner-profile').text(data.learnerProfileName)
  #   @joinSessionModal.find('.sessions').text(data.sessions)
  #   @joinSessionModal.removeClass('hidden inactive')
  #   @playAlert()

  # hidePrompt: (data)=>
  #   @joinSessionModal.addClass('inactive').find('.student-name').text('')
  #   @stopAlert()

  # joinSession: (data)=>
  #   @stopAlert()
  #   window.location = data.url

  # playAlert: =>
  #   @joinSessionModal.find('audio:first')[0].play()

  # stopAlert: =>
  #   @joinSessionModal.find('audio:first')[0].pause()
  #   @joinSessionModal.find('audio:first')[0].currentTime = 0
