class ZipcodesController < ApplicationController
  # GET /.well-knwon/acme-challenge/code

  def show
    @codes = {
      'z4dCYPJSIfryKDx850HTDuSsq6N9UPyTt67OCQ8dmro' => 'z4dCYPJSIfryKDx850HTDuSsq6N9UPyTt67OCQ8dmro.Ot3YH21kZ4-q-nr9RPA6uCrnRpz8xmE83x7zDBEu3BI',
      'OkqT41MPdeed9qVZDkBYlPVWlNwTNtv3mmKhDLrE8Ww' => 'OkqT41MPdeed9qVZDkBYlPVWlNwTNtv3mmKhDLrE8Ww.Ot3YH21kZ4-q-nr9RPA6uCrnRpz8xmE83x7zDBEu3BI',
      'XjyxR5J4aCtsGoSAPSIRD-_1pKKCkdBGk1fkhzvo2nc' => 'XjyxR5J4aCtsGoSAPSIRD-_1pKKCkdBGk1fkhzvo2nc.Ot3YH21kZ4-q-nr9RPA6uCrnRpz8xmE83x7zDBEu3BI',
      'lIl3caXA2J8IDKIq5cPQ0PGeVbESUIvsjdGdbePefvw' => 'lIl3caXA2J8IDKIq5cPQ0PGeVbESUIvsjdGdbePefvw.Ot3YH21kZ4-q-nr9RPA6uCrnRpz8xmE83x7zDBEu3BI'
    }


    render :text => @codes{ params[:id] }

  end
end
