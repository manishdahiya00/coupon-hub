class CreateAppOpens < ActiveRecord::Migration[7.1]
  def change
    create_table :app_opens do |t|
      t.references :user, null: false, foreign_key: true
      t.string :source_ip
      t.string :version_name
      t.string :version_code

      t.timestamps
    end
  end
end
