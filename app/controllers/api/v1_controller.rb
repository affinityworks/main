module Api
  class V1Controller < ApplicationController
    respond_to :json

    def show
      respond_to do |format|
        format.json do
          render(json: {
            "_links" => {
              "osdi:people" => {
                # unsafe!
                href: "#{request.url}/people",
                title: "The collection of people in the system"
              }
            },
            docs: {
              href: "https://github.com/wufm/osdi-docs",
              title: "Documentation",
              name: "Docs",
              index: "index"
            },
            self: {
              href: request.url,
              title: "The root API Entry Point (Your are here)"
            }
          })
        end
      end
    end
  end
end
