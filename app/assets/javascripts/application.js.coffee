#= require_self
#= require jquery
#= require jquery_ujs
#= require bootstrap
#= require underscore
#= require jstz.min
#= require jquery.ui.datepicker
#= require jquery_plugins/jquery.cookie
#= require_tree ./views
#= require_directory .

if !window.MutationObserver?
  class window.MutationObserver
    observe: ->
    disconnect: ->

window.Bte ||= {}
Bte.Views ||= {}
Bte.Views.Lessons ||= {}

Bte.log = (msg)-> console?.log?(msg) if Bte.DEBUG
window.createTriggerFunctionFor =
  Bte.createTriggerFunctionFor = (namespace)-> (evt)-> ->
    args = [].slice.call(arguments)
    args.shift()
    $(document).trigger("#{namespace}:#{evt}", args)

Bte.init = ->
  (new Bte.UI).render()

  #= Set timezone cookie ===
  $.cookie 'tz_olson', jstz.determine().name(), { path: '/' }

  appData = $('body').data()
  currentUserData = $('#current-user').data()

  Bte.DEBUG        = appData['debug']
  Bte.CURRENT_USER = new Bte.CurrentUser(currentUserData)

  if viewName = appData['view']
    [viewsClass, viewName] = viewName.split(".")

    if Bte.Views[viewsClass]?[viewName]?
      (window.view = new Bte.Views[viewsClass][viewName]).render()
