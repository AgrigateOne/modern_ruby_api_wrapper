# frozen_string_literal: true

require 'drb/drb'

DRb.start_service
remote_object = DRbObject.new_with_uri('druby://localhost:9998')

puts remote_object.check_state
