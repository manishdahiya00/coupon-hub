class CreateWebUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :web_users do |t|
      t.string :social_name
      t.string :social_email
      t.string :social_img_url
      t.string :social_token
      t.string :social_type
      t.string :source_ip
      t.string :security_token

      t.timestamps
    end
  end
end
