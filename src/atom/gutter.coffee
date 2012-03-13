{View, $$$} = require 'space-pen'

$ = require 'jquery'
_ = require 'underscore'

module.exports =
class Gutter extends View
  @content: ->
    @div class: 'gutter'

  renderLineNumbers: ->
    lastRow = -1
    rows = @parentView.bufferRowsForScreenRows()
    this[0].innerHTML = $$$ ->
      for row in rows
        @div {class: 'line-number'}, if row == lastRow then '•' else row + 1
        lastRow = row
