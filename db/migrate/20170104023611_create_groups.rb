class CreateGroups < ActiveRecord::Migration[5.0]
  def change
    create_table :groups do |t|
      t.string :origin_system
      t.string :name
      t.string :description
      t.string :summary
      t.string :browser_url
      t.string :featured_image_url
      t.integer :creator_id, :index => true
      t.integer :modified_by_id, :index => true

      t.timestamps
    end

    create_table :people_groups, id: false do |t|
      t.belongs_to :person, index: true
      t.belongs_to :group, index: true
    end

    create_table :events_groups, id: false do |t|
      t.belongs_to :event, index: true
      t.belongs_to :group, index: true
    end

    create_table :advocacy_campaigns_groups, id: false do |t|
      t.belongs_to :advocacy_campaign, index: true
      t.belongs_to :group, index: true
    end

    create_table :canvassing_efforts_groups, id: false do |t|
      t.belongs_to :canvassing_effort, index: true
      t.belongs_to :group, index: true
    end

    create_table :groups_petitions, id: false do |t|
      t.belongs_to :petition, index: true
      t.belongs_to :group, index: true
    end

    create_table :groups_share_pages, id: false do |t|
      t.belongs_to :share_page, index: true
      t.belongs_to :group, index: true
    end


    create_table :forms_groups, id: false do |t|
      t.belongs_to :form, index: true
      t.belongs_to :group, index: true
    end


  end
end
