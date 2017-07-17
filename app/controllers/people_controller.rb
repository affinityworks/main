class PeopleController < ApplicationController
  before_action :set_person, only: [:show, :edit, :update, :destroy]
  before_action :set_group
  before_action :authorize_group_access

  # GET /group/:id/people
  # GET /group/:id/people.json
  def index
    @people = Person.all
  end

  # GET /group/:id/people/1
  # GET /group/:id/people/1.json
  def show
  end

  # GET /group/:id/people/new
  def new
    @person = Person.new
  end

  # GET /group/:id/people/1/edit
  def edit
  end

  # POST /group/:id/people
  # POST /group/:id/people.json
  def create
    @person = Person.new(person_params)

    respond_to do |format|
      if @person.save
        format.html { redirect_to @person, notice: 'Person was successfully created.' }
        format.json { render :show, status: :created, location: @person }
      else
        format.html { render :new }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /group/:id/people/1
  # PATCH/PUT /group/:id/people/1.json
  def update
    respond_to do |format|
      if @person.update(person_params)
        format.html { redirect_to @person, notice: 'Person was successfully updated.' }
        format.json { render :show, status: :ok, location: @person }
      else
        format.html { render :edit }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /group/:id/people/1
  # DELETE /group/:id/people/1.json
  def destroy
    @person.destroy
    respond_to do |format|
      format.html { redirect_to group_people_url, notice: 'Person was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_person
      @person = Person.find(params[:id])
    end

    def set_group
      @group = Group.find(params[:group_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def person_params
      params.fetch(:person, {})
    end
end
