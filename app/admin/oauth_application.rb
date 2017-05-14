ActiveAdmin.register Doorkeeper::Application, as: "Oauth Application"  do
  permit_params :name, :redirect_uri, :scopes
end
