// Generated by CoffeeScript 1.7.1
var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

window.App = (function(_super) {
  __extends(App, _super);

  function App() {
    this.increaseBet = __bind(this.increaseBet, this);
    this.decreaseBet = __bind(this.decreaseBet, this);
    this.dealerPlay = __bind(this.dealerPlay, this);
    this.adjustScore = __bind(this.adjustScore, this);
    this.dealHand = __bind(this.dealHand, this);
    return App.__super__.constructor.apply(this, arguments);
  }

  App.prototype.initialize = function() {
    var deck;
    this.set('myScore', 0);
    this.set('money', 100);
    this.set('bet', 5);
    this.set('dealerScore', 0);
    this.set('deck', deck = new Deck());
    return this.dealHand();
  };

  App.prototype.dealHand = function() {
    var deck;
    if ((this.get('deck')).length <= 10) {
      this.set('deck', deck = new Deck());
    }
    this.set('playerHand', this.get('deck').dealPlayer());
    this.set('dealerHand', this.get('deck').dealDealer());
    this.get('playerHand').on('flipCard', (function(_this) {
      return function() {
        return _this.get('dealerHand').models[0].flip();
      };
    })(this));
    return this.get('playerHand').on('checkWinner', (function(_this) {
      return function() {
        var dealerScore, playerScore;
        playerScore = _this.getScore(_this.get('playerHand').scores());
        if (playerScore <= 21) {
          _this.dealerPlay();
        }
        dealerScore = _this.getScore(_this.get('dealerHand').scores());
        if (playerScore <= 21 && ((playerScore > dealerScore) || dealerScore > 21)) {
          _this.set('myScore', _this.get('myScore') + 1);
          _this.adjustScore('win');
        } else {
          _this.set('dealerScore', _this.get('dealerScore') + 1);
          _this.adjustScore('lose');
        }
        if ((_this.get('money')) > 0) {
          return setTimeout((function() {
            _this.dealHand();
            $('.inc-button').addClass('active');
            return $('.dec-button').addClass('active');
          }), 2000);
        }
      };
    })(this));
  };

  App.prototype.getScore = function(scores) {
    if (scores.length === 1) {
      return scores[0];
    } else if (scores[1] > 21) {
      return scores[0];
    } else {
      return scores[1];
    }
  };

  App.prototype.adjustScore = function(outcome) {
    if (outcome === 'win') {
      this.set('money', (this.get('money')) + (this.get('bet')));
      return this.set('bet', 5);
    } else {
      this.set('money', (this.get('money')) - (this.get('bet')));
      this.set('bet', 5);
      if ((this.get('money')) === 0) {
        this.trigger('noMoney');
        return this.set('bet', 0);
      }
    }
  };

  App.prototype.dealerPlay = function() {
    var currScore, _results;
    currScore = this.getScore(this.get('dealerHand').scores());
    _results = [];
    while (currScore < 17) {
      this.get('dealerHand').hit();
      _results.push(currScore = this.getScore(this.get('dealerHand').scores()));
    }
    return _results;
  };

  App.prototype.decreaseBet = function() {
    var currBet;
    currBet = this.get('bet');
    currBet -= 5;
    if (currBet < 5 && (this.get('money')) > 0) {
      currBet = 5;
    } else if ((this.get('money')) === 0) {
      currBet = 0;
    }
    return this.set('bet', currBet);
  };

  App.prototype.increaseBet = function() {
    var currBet, totMoney;
    currBet = this.get('bet');
    totMoney = this.get('money');
    currBet += 5;
    if (currBet > totMoney) {
      currBet = totMoney;
    }
    if ((this.get('money')) === 0) {
      currBet = 0;
    }
    return this.set('bet', currBet);
  };

  return App;

})(Backbone.Model);
