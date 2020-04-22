json.extract! event, :id, :template_version, :friendly_from, :subject, :ip_pool, :sending_domain, :rcpt_tags, :event_type, :raw_rcpt_to, :msg_from, :rcpt_to, :transmission_id, :rcpt_meta, :message_id, :recipient_domain, :event_id, :routing_domain, :sending_ip, :template_id, :injection_time, :msg_size, :timestamp, :created_at, :updated_at
json.url event_url(event, format: :json)
