require_relative 'candidate_formatter'
require_relative 'db_connector'

db_connect = DbConnector.new
db_connect.form_array_from_db_select

corrected_array = CandidateFormatter.new(db_connect.array_from_db).call

db_connect.update_table(corrected_array)
