class CreateContracts < ActiveRecord::Migration[5.1]
  def change
    create_table :contracts, id: :uuid do |t|
      t.references :user, type: :uuid, index: true, foreign_key: true
      t.string :vendor
      t.datetime :starts_on
      t.datetime :ends_on
      t.money :price

      t.timestamps
    end
  end
end
