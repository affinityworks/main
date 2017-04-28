class Api::V1::PeopleController < Api::V1::BaseApiController
  def index
    respond_to do |format|
      format.json do
        render json: Api::Collections::PeopleRepresenter.new(people, request)
      end
    end
  end

  private

  def people
    Api::Collections::People.new(
      Person.includes(:email_addresses).page(params[:page]).per(params[:per_page])
    )
  end
end
