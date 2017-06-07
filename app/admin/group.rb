ActiveAdmin.register Group do

  permit_params :name, :description, :creator, :origin_system, :summary, :browser_url, :featured_image_url,
    :modified_by, :an_api_key, :synced_at, :address

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end


end
