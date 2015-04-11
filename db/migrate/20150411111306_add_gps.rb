class AddGps < ActiveRecord::Migration
  def change

	  change_table :devicetypes do |t|
	      t.boolean :gps
	  end
  end
end
