class CreateEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :events do |t|
      t.integer :template_version
      t.string :friendly_from
      t.string :subject
      t.string :ip_pool
      t.string :sending_domain
      t.text :rcpt_tags, array: true, default: []
      t.string :type
      t.string :raw_rcpt_to
      t.string :msg_from
      t.string :rcpt_to
      t.string :report_to
      t.integer :transmission_id
      t.string :fbtype
      t.json :rcpt_meta
      t.string :message_id
      t.string :recipient_domain
      t.string :report_by
      t.integer :event_id
      t.string :routing_domain
      t.float :sending_ip
      t.string :template_id
      t.string :delv_method
      t.timestamp :injection_time
      t.integer :msg_size
      t.timestamp :timestamp
      t.datetime :formattedDate

      t.timestamps
    end
  end
end
