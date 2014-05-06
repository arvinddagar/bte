class Bte.Views.Lessons.NewView
  render: ->
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