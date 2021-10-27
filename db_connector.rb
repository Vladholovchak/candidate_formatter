require 'bundler/setup'
require 'mysql2'

class DbConnector
  attr_reader :array_from_db

  def initialize
    @client = Mysql2::Client.new(host: 'db09', username: 'loki', password: 'v4WmZip2K67J6Iq7NXC', database: 'applicant_tests')
    @array_from_db = []
  end

  def form_array_from_db_select
    results = @client.query('SELECT candidate_office_name FROM hle_dev_test_vholovchak')
    results.each do |row|
      @array_from_db << row['candidate_office_name']
    end
  end

  def update_table(corrected_array)
    corrected_array.each_with_index do |element, index|
      sentence = "The candidate is running for the #{element} office."
      @client.query("UPDATE hle_dev_test_vholovchak SET clean_name = \"#{element}\", sentence = \"#{sentence}\" WHERE id = '#{index + 1}'")
    end
    @client.close
  end
end
