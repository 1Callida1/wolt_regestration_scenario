# frozen_string_literal: true

require './wolt_headless_registration_helper'

helper = Helper.new

@session = helper.generate_session
@session.visit('https://temp-mail.org/en/')
sleep(6)
email = @session.first("input[id*='mail']").value

puts "[log] Visited temp-mail, was get a email adress #{email}"

@session.visit('https://wolt.com/en/')

puts '[log] Visit wolt.com'

response_resoult = helper.phone_number_get
p response_resoult
id_number = response_resoult.split(':380').first
phone_number_from_response = response_resoult.split(':380').last
puts "[log] Get phone number #{phone_number_from_response} and id of response #{id_number}"

helper.get_phone_activate(id_number)
account = helper.account_create(phone_number_from_response)
puts '[log] Account was create'
helper.registration(account, email, id_number)

helper.watch_video_fake_activity
sleep(2)
helper.address_fake_activity
sleep(2)
helper.settings_edit_fake_activity
sleep(2)
helper.options_check_fake_activity
sleep(2)
helper.serach_fake_activity
sleep(2)

sleep(rand(2..10))
