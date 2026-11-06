class CreateServices < ActiveRecord::Migration[8.1]
  def change
    create_table :services do |t|
      t.string :name, null: false
      t.integer :duration_minutes, null: false
      t.integer :price_cents, null: false
      t.boolean :active, null: false, default: true

      t.timestamps
    end

    add_check_constraint :services, "duration_minutes > 0", name: "services_duration_minutes_positive"
    add_check_constraint :services, "price_cents >= 0", name: "services_price_cents_non_negative"
  end
end
