class window.Hand extends Backbone.Collection

  model: Card

  initialize: (array, @deck, @isDealer) ->

  hit: ->
    @add(@deck.pop()).last()

  # Implement stand function
  # If standing, round ends, check score
  # Score is highest score unless that score is over 21
  stand: ->
    results = @scores()
    result = if results.length ==1
      results[0]
    else if results[1] > 21
      results[0]
    else
      results[1]

    if result<=21 then @trigger('incrementScore', this)
    # if result<=21 then console.log result

  scores: ->
    # The scores are an array of potential scores.
    # Usually, that array contains one element. That is the only score.
    # when there is an ace, it offers you two scores - the original score, and score + 10.
    hasAce = @reduce (memo, card) ->
      memo or card.get('value') is 1
    , false
    
    score = @reduce (score, card) ->
      score + if card.get 'revealed' then card.get 'value' else 0
    , 0
  
    if hasAce then [score, score + 10] else [score]
