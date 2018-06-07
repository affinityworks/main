class StaticFeatureTogglesController < ApplicationController
  before_action :set_feature
  before_action :set_group

  def index
    render json: { @feature => StaticFeatureToggle.on?(@feature, @group) }
  end

  private

  def set_feature
    sym = params.require(:feature).to_sym
    @feature = sym if StaticFeatureToggle::FEATURES.include? sym
  end

  def set_group
    @group = Group.find(params.require(:group_id).to_i)
  end
end
