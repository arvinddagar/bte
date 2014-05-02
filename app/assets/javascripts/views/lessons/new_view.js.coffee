class Bte.Views.Lessons.NewView
  render: ->
    # $("#lesson_end_date").datepicker({defaultDate: -1})
    # $("#lesson_start_date").datepicker({defaultDate: -1})
    $(document)
      .on('change', '#lessons_category', @showSubCategory)

  showSubCategory: (event)->
   $.ajax
     url: '/subcategory'
     data:
       {parent_id: this.value}
     type: 'get'
     success: (data)->
         $('#subcategory').html(data)
     complete: ->