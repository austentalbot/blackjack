class window.AppView extends Backbone.View

  template: _.template '
    <div class="buttons">
      <div class="hit-button">Hit</div> <div class="stand-button">Stand</div> <div class="inc-button">Increase Bet $5</div> <div class="dec-button">Decrease Bet $5</div> <div class="bet"></div>
    </div>
    <div class="scores myScore"></div>
    <div class="scores dealerScore"></div>
    <div class="scores money"></div>
    <div class="player-hand-container"></div>
    <div class="dealer-hand-container"></div>
  '

  events:
    "click .hit-button": -> @model.get('playerHand').hit()
    "click .stand-button": -> @model.get('playerHand').stand()
    "click .inc-button": ->
      currBet = @model.get 'bet'
      totMoney = @model.get 'money'
      currBet+=5
      if currBet>totMoney
        currBet = totMoney
      @model.set 'bet', currBet
    "click .dec-button": ->
      currBet = @model.get 'bet'
      currBet-=5
      if currBet<5
        currBet = 5
      @model.set 'bet', currBet

  initialize: ->
    @render()

    @model.on 'noMoney', =>
      console.log('poor!')
      $('body').append('<div class="lose"> GAME OVER </div>')
      $('.lose').css({top: $('body').height()*.2, left: $('body').width()*.2, position:'absolute'})

      
    @model.on 'change', =>
      @render()



  render: ->
    @$el.children().detach()
    @$el.html @template()
    @$('.myScore').text('Hands won: '+@model.get 'myScore')
    @$('.dealerScore').text('Hands lost: '+@model.get 'dealerScore')
    @$('.money').text('Money: $'+@model.get 'money')
    @$('.bet').text('Bet: $'+@model.get 'bet')
    @$('.player-hand-container').html new HandView(collection: @model.get 'playerHand').el
    @$('.dealer-hand-container').html new HandView(collection: @model.get 'dealerHand').el
