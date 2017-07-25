class FacebookPagesController < InheritedResources::Base

  private

    def facebook_page_params
      params.require(:facebook_page).permit()
    end
end

