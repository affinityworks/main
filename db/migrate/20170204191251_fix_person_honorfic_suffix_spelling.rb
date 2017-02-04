class FixPersonHonorficSuffixSpelling < ActiveRecord::Migration[5.0]
  def change
    rename_column :people, :honorific_sufix, :honorific_suffix
  end
end
