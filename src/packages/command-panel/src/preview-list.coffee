$ = require 'jquery'
{$$$} = require 'space-pen'
ScrollView = require 'scroll-view'
_ = require 'underscore'

module.exports =
class PreviewList extends ScrollView
  @content: ->
    @ol class: 'preview-list', tabindex: -1, ->

  selectedOperationIndex: 0
  operations: null

  initialize: (@rootView) ->
    super
    @on 'core:move-down', => @selectNextOperation(); false
    @on 'core:move-up', => @selectPreviousOperation(); false
    @on 'core:confirm', => @executeSelectedOperation()

    @on 'mousedown', 'li.operation', (e) =>
      @setSelectedOperationIndex(parseInt($(e.target).closest('li').data('index')))
      @executeSelectedOperation()

  destroy: ->
    @destroyOperations() if @operations

  hasOperations: -> @operations?

  populate: (operations) ->
    @destroyOperations() if @operations
    @operations = operations
    @empty()
    @html $$$ ->
      operation.index = index for operation, index in operations
      operationsByPath = _.groupBy(operations, (operation) -> operation.getPath())
      for path, ops of operationsByPath
        @li =>
          @span path, outlet: "path", class: "path"
        for operation in ops
          {prefix, suffix, match, range} = operation.preview()
          @li 'data-index': operation.index, class: 'operation', =>
            @span "#{range.start.row}:", class: "path"
            @span outlet: "preview", class: "preview", =>
              @span prefix
              @span match, class: 'match'
              @span suffix

    @setSelectedOperationIndex(0)
    @show()

  selectNextOperation: ->
    @setSelectedOperationIndex(@selectedOperationIndex + 1)

  selectPreviousOperation: ->
    @setSelectedOperationIndex(@selectedOperationIndex - 1)

  setSelectedOperationIndex: (index) ->
    index = Math.max(0, index)
    index = Math.min(@operations.length - 1, index)
    @children(".selected").removeClass('selected')
    element = @children("li.operation:eq(#{index})")
    element.addClass('selected')
    @scrollToElement(element)
    @selectedOperationIndex = index

  executeSelectedOperation: ->
    operation = @getSelectedOperation()
    editSession = @rootView.open(operation.getPath())
    bufferRange = operation.execute(editSession)
    editSession.setSelectedBufferRange(bufferRange, autoscroll: true) if bufferRange
    @rootView.focus()
    false

  getOperations: ->
    new Array(@operations...)

  destroyOperations: ->
    operation.destroy() for operation in @getOperations()
    @operations = null

  getSelectedOperation: ->
    @operations[@selectedOperationIndex]

  scrollToElement: (element) ->
    top = @scrollTop() + element.position().top
    bottom = top + element.outerHeight()

    if bottom > @scrollBottom()
      @scrollBottom(bottom)
    if top < @scrollTop()
      @scrollTop(top)
