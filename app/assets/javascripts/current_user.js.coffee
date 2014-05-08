class Bte.CurrentUser
  constructor: (data={})->
    @type     = data.type

    switch @type
      when "student" then @signInStudent()
      when "tutor" then @signInTutor()

  signInStudent: =>


  signInTutor: =>

    $(document)
