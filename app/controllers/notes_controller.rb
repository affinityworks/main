class NotesController < ApplicationController
  protect_from_forgery except: :create #TODO: Add the csrf token in react.

  TYPE_MAPPING = {
    'membership' => Membership
  }

  def create
    render_not_found and return unless resource

    resource.notes.create(
      author: current_person,
      text: notes_params[:text]
    )

    respond_to do |format|
      format.json do
        render json: JsonApi::NotesRepresenter.new(resource.notes.last).to_json
      end
    end
  end

  private

  def resource
    model = TYPE_MAPPING[notes_params[:resource_type]] or return
    @resource ||= model.find(notes_params[:resource_id])
  end

  def notes_params
    params.require(:note).permit(:text, :resource_type, :resource_id)
  end
end
