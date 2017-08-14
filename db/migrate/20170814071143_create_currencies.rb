class CreateCurrencies < ActiveRecord::Migration[5.1]
  def change
    create_table :currencies do |t|
      t.string :name
      t.text :min_date
      t.text :max_date
      t.decimal :history_sold
      t.decimal :history_bought
      t.decimal :current_sell
      t.decimal :current_buy

      t.timestamps
    end
  end
end
