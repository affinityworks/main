class MembershipTagsController < ApplicationController
  before_action :authenticate_person!
  before_action :authorize_group_access

  protect_from_forgery except: [:create] #TODO: Add the csrf token in react.

  def create
    membership = Membership.find(params[:membership_id])

    membership.tag_list.add(params[:tag_name])
    membership.save

    respond_to do |format|
      format.html
      format.json do
        render json: JsonApi::TagsRepresenter.new(membership.tags.last).to_json
      end
    end
  end

  def destroy
    membership = Membership.find(params[:membership_id])
    tag = membership.tags.find(params[:id])

    tag.destroy
    respond_to do |format|
      format.html { redirect_to groups_url, notice: 'Tag successfully destroyed.' }
      format.json { head :no_content }
    end
  end
end
