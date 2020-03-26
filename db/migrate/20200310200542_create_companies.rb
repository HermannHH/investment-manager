class CreateCompanies < ActiveRecord::Migration[6.0]
  def change
    create_table :companies do |t|
      t.string :ticker, unique: true
      t.string :name
      t.text :description
      t.string :sector
      t.string :industry
      t.timestamps
    end
  end
end
