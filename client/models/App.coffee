#todo: refactor to have a game beneath the outer blackjack model
class window.App extends Backbone.Model

  initialize: ->
    @set 'myScore', 0
    @set 'money', 100
    @set 'bet', 5
    @set 'dealerScore', 0
    @set 'deck', deck = new Deck()
    @dealHand()

  dealHand: =>
    # set up new deck if necessary
    if (@get 'deck').length <=10
      @set 'deck', deck = new Deck()
    # deal out
    @set 'playerHand', @get('deck').dealPlayer()
    @set 'dealerHand', @get('deck').dealDealer()
    #compare hands, adjust score, and redeal
    @get('playerHand').on 'flipCard', =>
      @get('dealerHand').models[0].flip()

    @get('playerHand').on 'checkWinner', =>
      playerScore=@getScore(@get('playerHand').scores())
      if playerScore<=21
        @dealerPlay()
      dealerScore=@getScore(@get('dealerHand').scores())
      if playerScore<=21 and ((playerScore > dealerScore) || dealerScore>21)
        @set('myScore', @get('myScore')+1)
        @adjustScore('win')
      else
        @set('dealerScore', @get('dealerScore')+1)
        @adjustScore('lose')
      # Redeal
      if (@get 'money')>0
        setTimeout (=>
          @dealHand()
          $('.inc-button').addClass('active')
          $('.dec-button').addClass('active')
        ), 2000

  getScore: (scores) ->
    if scores.length ==1
      scores[0]
    else if scores[1] > 21
      scores[0]
    else
      scores[1]

  # adjust money and reset bet to five
  adjustScore: (outcome) =>
    if outcome=='win'
      @set 'money', (@get 'money')+(@get 'bet')
      @set 'bet', 5
    else
      @set 'money', (@get 'money')-(@get 'bet')
      @set 'bet', 5
      #check if money is zero
      if (@get 'money') is 0
        @trigger 'noMoney'
        @set 'bet', 0

  dealerPlay: =>
    currScore=@getScore(@get('dealerHand').scores())
    while currScore < 17
      #add card to dealer's
      @get('dealerHand').hit()
      currScore=@getScore(@get('dealerHand').scores())

  decreaseBet: =>
    currBet = @get 'bet'
    currBet-=5
    if currBet<5 && (@get 'money')>0
      currBet = 5
    else if (@get 'money')==0
      currBet = 0
    @set 'bet', currBet

  increaseBet: =>
    currBet = @get 'bet'
    totMoney = @get 'money'
    currBet+=5
    if currBet>totMoney
      currBet = totMoney
    if (@get 'money') == 0
      currBet=0
    @set 'bet', currBet


