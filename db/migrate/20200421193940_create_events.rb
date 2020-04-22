class CreateEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :events do |t|
      t.integer :template_version
      t.string :friendly_from
      t.string :subject
      t.string :ip_pool
      t.string :sending_domain
      t.text :rcpt_tags, array: true, default: []
      t.string :event_type
      t.string :raw_rcpt_to
      t.string :msg_from
      t.string :rcpt_to
      t.string :report_to
      t.bigint :transmission_id
      t.string :fbtype
      t.json :rcpt_meta
      t.string :message_id
      t.string :recipient_domain
      t.string :report_by
      t.bigint :event_id
      t.string :routing_domain
      t.string :sending_ip
      t.string :template_id
      t.string :delv_method
      t.timestamp :injection_time
      t.integer :msg_size
      t.timestamp :timestamp

      t.timestamps
    end
  end
end
