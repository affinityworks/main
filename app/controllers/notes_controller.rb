class NotesController < ApplicationController
  protect_from_forgery except: :create #TODO: Add the csrf token in react.

  def create
    
  end
end
