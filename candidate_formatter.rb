require 'pry'
class CandidateFormatter
  def initialize(array)
    super()
    @array = array
  end

  ABBREVIATION_LIST = %w[twp hwy].freeze
  FULL_NAME_LIST = %w[Township Highway].freeze

  def call
    @array.map! do |string|
      lower_cased = string.downcase
      cleared_from_slashes = change_with_slash(lower_cased)
      cleared_from_commas = change_with_comma(cleared_from_slashes)
      without_abbreviations = change_abbreviations(cleared_from_commas)
      without_duplicates = clear_duplicate(without_abbreviations)
      delete_periods(without_duplicates)
    end
    @array
  end

  def change_with_slash(string)
    if string.include?('/')
      array = string.rpartition('/')
      "#{array.last.split(' ').first&.capitalize} #{array.last.split(' ').last} #{array.first.gsub(/\//, ' and ')}"
    else
      string
    end
  end

  def change_with_comma(string)
    if string.include?(',')
      array = string.rpartition(', ')
      "#{array.first} (#{array.last.split(' ').map(&:capitalize).join(' ')})"
    else
      string
    end
  end

  def change_abbreviations(string)
    if (string.downcase.split(' ') & ABBREVIATION_LIST).empty?
      string
    else
      ABBREVIATION_LIST.each_with_index do |word, index|
        string.gsub!(/#{word}/, FULL_NAME_LIST[index])
      end
    end
    string
  end

  def delete_periods(string)
    string.gsub(/\./, '')
  end

  def clear_duplicate(string)
    string.split(' ').uniq.join(' ')
  end
end
