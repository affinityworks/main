class MembersController < ApplicationController
  before_action :authenticate_person!
  before_action :set_members, only: :index
  before_action :authorize_group_access

  protect_from_forgery except: [:update, :create] #TODO: Add the csrf token in react.

  def index
    respond_to do |format|
      format.html
      format.json do
        render json: {
          members: JsonApi::PeopleRepresenter.for_collection.new(Person.add_event_attended(@members, current_group)),
          total_pages: @members.total_pages,
          page: @members.current_page
        }.to_json
      end
    end
  end

  def show
    respond_to do |format|
      format.html
      format.json do
        person = Person.find(params[:id])
        render json: JsonApi::PeopleRepresenter.new(person).to_json
      end
    end
  end

  private

  def set_members
    @members = Group.find(params[:group_id]).all_members.includes(
      [:email_addresses, :personal_addresses, :phone_numbers]
    ).page(params[:page])

    if params[:filter]
      #in the future we might want ot search all fields like address, town, city, state... etc....
      @members = @members.where('given_name ilike ? or family_name ilike ?', "%#{params[:filter]}%","%#{params[:filter]}%")
      #members = Member.arel_table
      #wildcard_search = "%#{params[:filter]}%"

      #@members = @members.where('given_name ilike :search or family_name ilike :search', :search wildcard_search)
    elsif params[:email]
      @members = @members.by_email(params[:email])
    end

    if params[:sort]
      @members = @members.order(params[:sort] => params[:direction])
    end
  end
end
