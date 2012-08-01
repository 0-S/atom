module.exports =
class Point
  @fromObject: (object) ->
    if object instanceof Point
      object
    else
      if object instanceof Array
        [row, column] = object
      else
        { row, column } = object

      new Point(row, column)

  constructor: (@row=0, @column=0) ->

  copy: ->
    new Point(@row, @column)

  add: (other) ->
    other = Point.fromObject(other)
    row = @row + other.row
    if other.row == 0
      column = @column + other.column
    else
      column = other.column

    new Point(row, column)

  subtract: (other) ->
    other = Point.fromObject(other)
    row = @row - other.row
    if @row == other.row
      column = @column - other.column
    else
      column = @column

    new Point(row, column)

  splitAt: (column) ->
    if @row == 0
      rightColumn = @column - column
    else
      rightColumn = @column

    [new Point(0, column), new Point(@row, rightColumn)]

  compare: (other) ->
    if @row > other.row
      1
    else if @row < other.row
      -1
    else
      if @column > other.column
        1
      else if @column < other.column
        -1
      else
        0

  isEqual: (other) ->
    return false unless other
    other = Point.fromObject(other)
    @row == other.row and @column == other.column

  isLessThan: (other) ->
    @compare(other) < 0

  isLessThanOrEqual: (other) ->
    @compare(other) <= 0

  isGreaterThan: (other) ->
    @compare(other) > 0

  isGreaterThanOrEqual: (other) ->
    @compare(other) >= 0

  inspect: ->
    "(#{@row}, #{@column})"

  toString: ->
    "#{@row},#{@column}"

  toArray: ->
    [@row, @column]

  serialize: ->
    @toArray()
