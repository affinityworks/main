class FeatureTogglesController < ApplicationController
  before_action :set_feature
  before_action :set_group

  def index
    render json: { @feature => FeatureToggle.on?(@feature, @group) }
  end

  private

  def set_feature
    sym = params.require(:feature).to_sym
    @feature = sym if FeatureToggle::FEATURES.include? sym
  end

  def set_group
    @group = Group.find(params.require(:group_id).to_i)
  end
end
