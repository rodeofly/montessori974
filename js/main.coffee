mode = "addition"
  
randomNum = (max,min=1) ->
  return Math.floor(Math.random() * (max - min) + min)
  # min is set to 0 by default but a different value can be passed to function

randomise = ->
  randomNum = @_randomNum(10)
  # returns a random integer between 0 and 10
  randomNumAlt = @_randomNum(10,5)
  # returns a random integer betwen 5 and 10

build_table = (ligne, colonne) ->
  $html = $( "<table></table>" )
  for l in [0..ligne]
    $html.append( "<tr id='row#{l}'></tr>" )  
    for c in [0..colonne]
      switch mode
        when "addition"
          $html.find("#row#{l}").append( "<td id='col#{l}' data-val='#{l+c}'>#{if ((l is 0) or (c is 0)) then l+c else ''}</td>" )
        when "multiplication"
          $html.find("#row#{l}").append( "<td id='col#{l}' data-val='#{l*c}'>#{if ((l is 0) or (c is 0)) then l+c else ''}</td>" )
  return $html

add_table = ->
  $table = build_table(9, 9) 
  $( "##{mode} #table" ).empty().append $table.html()
  $( "##{mode} #jetons" ).empty()
  for i in [1..9]
    for j in [1..9]  
      switch mode
        when "addition" 
          $( "##{mode} #jetons" ).append "<div class='jeton' data-val='#{i+j}'>#{i+j}</div>"
        when "multiplication" 
          $( "##{mode} #jetons" ).append "<div class='jeton' data-val='#{i*j}'>#{i*j}</div>"
  switch mode
    when "addition" 
      $( "##{mode} tr#row#{0} td:nth-child(#{1})" ).html "+"
    when "multiplication"  
      $( "##{mode} tr#row#{0} td:nth-child(#{1})" ).html "×"

  
  $(".jeton").draggable
    helper : "clone"
    cursor: "move"
    appendTo: "body"
    containment: "document"
    start: () -> $(this).hide()
    stop: () -> $(this).show()


  $("##{mode} td, #jetons").droppable
    hoverClass: "hoverDrop",
    tolerance: "pointer",
    drop: (event, ui) ->
      $(this).append(ui.draggable)


$ ->

  add_table()
  
  $( ".check" ).on "click", ->
    $( ".green" ).toggleClass "black green"
    $( ".red" ).toggleClass "black red"
    $( "##{mode} td" ).each ->
      if $(this).find(".jeton").length is 1
        cell = $(this).attr("data-val")
        jeton = $(this).find(".jeton").attr("data-val")
        if cell isnt jeton
          $( this ).removeClass( "black" ).addClass("red")
        else
          $( this ).removeClass( "black" ).addClass("green")
 
  $( "#add_table" ).on "click", ->
    mode = "addition"
    $( ".article" ).hide()
    $( "#post_addition" ).show()
    add_table()
  
  $( "#mult_table" ).on "click", ->
    mode = "multiplication"
    $( ".article" ).hide()
    $( "#post_multiplication" ).show()
    add_table()
  
  $( ".random" ).on "click", ->
    $( "##{mode} .black" ).removeClass "black"
    for i in [1..10]
      loop
        [l, c] = [randomNum(11,2), randomNum(11,2)]
        $cell = $( "##{mode} tr#row#{l} td:nth-child(#{c})" )
        break if not $cell.hasClass( "black" )
      $cell.addClass( "black" )
  
  $( ".correction" ).on "click", ->
    $( ".black, .green, .red" ).removeClass "black green red"
    $( ".jeton" ).each -> $( this ).appendTo $( "#jetons")
    for l in [1..10]
      for c in [1..10]
        $cell = $( "##{mode} tr#row#{l} td:nth-child(#{c+1})" )
        
        switch mode
          when "addition" 
            $cell.append $( "##{mode} #jetons .jeton[data-val='#{l+c}']:first()" )
          when "multiplication" 
            $cell.append $( "##{mode} #jetons .jeton[data-val='#{l*c}']:first()" )  
