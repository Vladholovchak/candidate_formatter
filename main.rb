# frozen_string_literal: true

require_relative 'candidate_formatter'
require_relative 'db_connector'
require 'mysql2'

DbConnector.new

array_from_db = []

client = Mysql2::Client.new(host: 'localhost', username: 'root', database: 'candidate_test')
results = client.query('SELECT candidate_office_name FROM hle_dev_test_vholovchak')
results.each do |row|
  array_from_db << row['candidate_office_name']
end

# test = ['Something Township, Lol Like',
#         'County Clerk/Recorder/DeKalb County',
#         'Highway Highway Clerk/Recorder/DeKalb County',
#         '1st circuit judge, Circuit Court',
#         'County Clerk/Recorder/DeKalb County',
#         'State Central Committeeman/12th District',
#         'Township Committeeman/Palos Twp',
#         'Judge, Circuit Court/15th Circuit'
#        ]

corrected_array = CandidateFormatter.new(array_from_db).call

corrected_array.each_with_index do |element, index|
  sentence = "The candidate is running for the #{element} office."
  client.query("UPDATE hle_dev_test_vholovchak SET clean_name ='#{element}', sentence = '#{sentence}' WHERE id = '#{index + 1}'")
end

client.close

