class window.AppView extends Backbone.View

  template: _.template '
    <div class="buttons">
      <div class="hit-button active">Hit</div> <div class="stand-button active">Stand</div> <div class="inc-button active">Increase Bet $5</div> <div class="dec-button active">Decrease Bet $5</div> <div class="bet"></div>
    </div>
    <div class="playerView">
      <div class="scores myScore"></div>
      <div class="scores dealerScore"></div>
      <div class="scores money"></div>
      <div class="player-hand-container"></div>
      <div class="dealer-hand-container"></div>
    </div>
  '

  events:
    "click .hit-button.active": ->
      $('.inc-button').removeClass('active')
      $('.dec-button').removeClass('active')
      @model.get('playerHand').hit()
    "click .stand-button.active": ->
      $('.inc-button').removeClass('active')
      $('.dec-button').removeClass('active')
      @model.get('playerHand').stand()
    "click .inc-button.active": ->
      @model.increaseBet()
    "click .dec-button.active": ->
      @model.decreaseBet()
    "change @model.get 'money'": =>
      if (@model.get 'money')<=0
        $('.hit-button').removeClass('active')
        $('.stand-button').removeClass('active')
        $('.inc-button').removeClass('active')
        $('.dec-button').removeClass('active')        


  initialize: ->
    @render()

    @model.on 'noMoney', =>
      $('.hit-button').removeClass('active')
      $('.stand-button').removeClass('active')
      $('.inc-button').removeClass('active')
      $('.dec-button').removeClass('active')
      $('body').append('<div class="lose"> GAME OVER </div>')
      $('.lose').css({top: $('body').height()*.2, left: $('body').width()*.2, position:'absolute'})
      console.log('poor!')

      
    @model.on 'change', =>
      @render()
      # remove active if player has money
      if (@model.get 'money') <= 0
        $('.hit-button').removeClass('active')
        $('.stand-button').removeClass('active')     


  render: ->
    @$el.children().detach()
    @$el.html @template()
    @$('.myScore').text('Hands won: '+@model.get 'myScore')
    @$('.dealerScore').text('Hands lost: '+@model.get 'dealerScore')
    @$('.money').text('Money: $'+@model.get 'money')
    @$('.bet').text('Bet: $'+@model.get 'bet')
    @$('.player-hand-container').html new HandView(collection: @model.get 'playerHand').el
    @$('.dealer-hand-container').html new HandView(collection: @model.get 'dealerHand').el
 
