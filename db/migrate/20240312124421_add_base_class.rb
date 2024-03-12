class AddBaseClass < ActiveRecord::Migration[7.1]
  def change
    create_table :base_classes do |t|
      t.string :type
    end
  end
end
