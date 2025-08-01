# typed: true

# DO NOT EDIT MANUALLY
# This is an autogenerated file for types exported from the `simplecov-lcov` gem.
# Please instead update this file by running `bin/tapioca gem simplecov-lcov`.


# source://simplecov-lcov//lib/simplecov-lcov.rb#7
module SimpleCov; end

# source://simplecov-lcov//lib/simplecov-lcov.rb#8
module SimpleCov::Formatter; end

# Custom Formatter to generate lcov style coverage for simplecov
#
# source://simplecov-lcov//lib/simplecov-lcov.rb#10
class SimpleCov::Formatter::LcovFormatter
  # generate lcov style coverage.
  # ==== Args
  # _result_ :: [SimpleCov::Result] abcoverage result instance.
  #
  # source://simplecov-lcov//lib/simplecov-lcov.rb#14
  def format(result); end

  private

  # source://simplecov-lcov//lib/simplecov-lcov.rb#62
  def create_output_directory!; end

  # source://simplecov-lcov//lib/simplecov-lcov.rb#121
  def filtered_branches(file); end

  # source://simplecov-lcov//lib/simplecov-lcov.rb#117
  def filtered_lines(file); end

  # source://simplecov-lcov//lib/simplecov-lcov.rb#125
  def format_branch(branch, branch_idx); end

  # source://simplecov-lcov//lib/simplecov-lcov.rb#101
  def format_branches(file); end

  # source://simplecov-lcov//lib/simplecov-lcov.rb#84
  def format_file(file); end

  # source://simplecov-lcov//lib/simplecov-lcov.rb#130
  def format_line(line); end

  # source://simplecov-lcov//lib/simplecov-lcov.rb#111
  def format_lines(file); end

  # source://simplecov-lcov//lib/simplecov-lcov.rb#50
  def lcov_results_path; end

  # source://simplecov-lcov//lib/simplecov-lcov.rb#46
  def output_directory; end

  # source://simplecov-lcov//lib/simplecov-lcov.rb#79
  def output_filename(filename); end

  # @return [Boolean]
  #
  # source://simplecov-lcov//lib/simplecov-lcov.rb#54
  def report_with_single_file?; end

  # source://simplecov-lcov//lib/simplecov-lcov.rb#58
  def single_report_path; end

  # source://simplecov-lcov//lib/simplecov-lcov.rb#67
  def write_lcov!(file); end

  # source://simplecov-lcov//lib/simplecov-lcov.rb#73
  def write_lcov_to_single_file!(files); end

  class << self
    # @yield [@config]
    #
    # source://simplecov-lcov//lib/simplecov-lcov.rb#27
    def config; end

    # source://simplecov-lcov//lib/simplecov-lcov.rb#33
    def report_with_single_file=(value); end
  end
end

# source://simplecov-lcov//lib/simple_cov_lcov/configuration.rb#1
module SimpleCovLcov; end

# source://simplecov-lcov//lib/simple_cov_lcov/configuration.rb#2
class SimpleCovLcov::Configuration
  # source://simplecov-lcov//lib/simple_cov_lcov/configuration.rb#24
  def lcov_file_name; end

  # Sets the attribute lcov_file_name
  #
  # @param value the value to set the attribute lcov_file_name to.
  #
  # source://simplecov-lcov//lib/simple_cov_lcov/configuration.rb#5
  def lcov_file_name=(_arg0); end

  # source://simplecov-lcov//lib/simple_cov_lcov/configuration.rb#11
  def output_directory; end

  # Sets the attribute output_directory
  #
  # @param value the value to set the attribute output_directory to.
  #
  # source://simplecov-lcov//lib/simple_cov_lcov/configuration.rb#4
  def output_directory=(_arg0); end

  # Sets the attribute report_with_single_file
  #
  # @param value the value to set the attribute report_with_single_file to.
  #
  # source://simplecov-lcov//lib/simple_cov_lcov/configuration.rb#3
  def report_with_single_file=(_arg0); end

  # @return [Boolean]
  #
  # source://simplecov-lcov//lib/simple_cov_lcov/configuration.rb#7
  def report_with_single_file?; end

  # source://simplecov-lcov//lib/simple_cov_lcov/configuration.rb#20
  def single_report_path; end

  # source://simplecov-lcov//lib/simple_cov_lcov/configuration.rb#15
  def single_report_path=(new_path); end
end
