class AddAddressLangauge < ActiveRecord::Migration[5.0]
  def change
    add_column :addresses, :language, :string
  end
end
