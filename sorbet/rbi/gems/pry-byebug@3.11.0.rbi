# typed: true

# DO NOT EDIT MANUALLY
# This is an autogenerated file for types exported from the `pry-byebug` gem.
# Please instead update this file by running `bin/tapioca gem pry-byebug`.


# source://pry-byebug//lib/byebug/processors/pry_processor.rb#5
module Byebug
  extend ::Byebug::Helpers::ReflectionHelper
end

class Byebug::DebugThread < ::Thread; end

# Extends raw byebug's processor.
#
# source://pry-byebug//lib/byebug/processors/pry_processor.rb#9
class Byebug::PryProcessor < ::Byebug::CommandProcessor
  # Called when a breakpoint is hit. Note that `at_line`` is called
  # inmediately after with the context's `stop_reason == :breakpoint`, so we
  # must not resume the pry instance here
  #
  # source://pry-byebug//lib/byebug/processors/pry_processor.rb#80
  def at_breakpoint(breakpoint); end

  # Called when the debugger wants to stop at a regular line
  #
  # source://pry-byebug//lib/byebug/processors/pry_processor.rb#64
  def at_line; end

  # Called when the debugger wants to stop right before a method return
  #
  # source://pry-byebug//lib/byebug/processors/pry_processor.rb#71
  def at_return(_return_value); end

  # source://pry-byebug//lib/byebug/processors/pry_processor.rb#14
  def bold(*args, **_arg1, &block); end

  # source://pry-byebug//lib/byebug/processors/pry_processor.rb#13
  def output(*args, **_arg1, &block); end

  # Set up a number of navigational commands to be performed by Byebug.
  #
  # source://pry-byebug//lib/byebug/processors/pry_processor.rb#45
  def perform(action, options = T.unsafe(nil)); end

  # Returns the value of attribute pry.
  #
  # source://pry-byebug//lib/byebug/processors/pry_processor.rb#10
  def pry; end

  # Sets the attribute pry
  #
  # @param value the value to set the attribute pry to.
  #
  # source://pry-byebug//lib/byebug/processors/pry_processor.rb#10
  def pry=(_arg0); end

  # Wrap a Pry REPL to catch navigational commands and act on them.
  #
  # source://pry-byebug//lib/byebug/processors/pry_processor.rb#26
  def run(&_block); end

  private

  # source://pry-byebug//lib/byebug/processors/pry_processor.rb#93
  def n_hits(breakpoint); end

  # source://pry-byebug//lib/byebug/processors/pry_processor.rb#114
  def perform_backtrace(_options); end

  # source://pry-byebug//lib/byebug/processors/pry_processor.rb#142
  def perform_down(options); end

  # source://pry-byebug//lib/byebug/processors/pry_processor.rb#130
  def perform_finish(*_arg0); end

  # source://pry-byebug//lib/byebug/processors/pry_processor.rb#150
  def perform_frame(options); end

  # source://pry-byebug//lib/byebug/processors/pry_processor.rb#120
  def perform_next(options); end

  # source://pry-byebug//lib/byebug/processors/pry_processor.rb#125
  def perform_step(options); end

  # source://pry-byebug//lib/byebug/processors/pry_processor.rb#134
  def perform_up(options); end

  # Resume an existing Pry REPL at the paused point.
  #
  # source://pry-byebug//lib/byebug/processors/pry_processor.rb#102
  def resume_pry; end

  class << self
    # source://pry-byebug//lib/byebug/processors/pry_processor.rb#16
    def start; end
  end
end

class Byebug::ThreadsTable; end

# source://pry-byebug//lib/pry/byebug/breakpoints.rb#3
class Pry
  extend ::Forwardable
end

# source://pry-byebug//lib/pry/byebug/breakpoints.rb#4
module Pry::Byebug; end

# Wrapper for Byebug.breakpoints that respects our Processor and has better
# failure behavior. Acts as an Enumerable.
#
# source://pry-byebug//lib/pry/byebug/breakpoints.rb#9
module Pry::Byebug::Breakpoints
  extend ::Enumerable
  extend ::Pry::Byebug::Breakpoints

  # Adds a file breakpoint.
  #
  # @raise [ArgumentError]
  #
  # source://pry-byebug//lib/pry/byebug/breakpoints.rb#63
  def add_file(file, line, expression = T.unsafe(nil)); end

  # Adds a method breakpoint.
  #
  # source://pry-byebug//lib/pry/byebug/breakpoints.rb#51
  def add_method(method, expression = T.unsafe(nil)); end

  # source://pry-byebug//lib/pry/byebug/breakpoints.rb#44
  def breakpoints; end

  # Changes the conditional expression for a breakpoint.
  #
  # source://pry-byebug//lib/pry/byebug/breakpoints.rb#78
  def change(id, expression = T.unsafe(nil)); end

  # Deletes an existing breakpoint with the given ID.
  #
  # @raise [ArgumentError]
  #
  # source://pry-byebug//lib/pry/byebug/breakpoints.rb#89
  def delete(id); end

  # Deletes all breakpoints.
  #
  # source://pry-byebug//lib/pry/byebug/breakpoints.rb#100
  def delete_all; end

  # Disables a breakpoint with the given ID.
  #
  # source://pry-byebug//lib/pry/byebug/breakpoints.rb#115
  def disable(id); end

  # Disables all breakpoints.
  #
  # source://pry-byebug//lib/pry/byebug/breakpoints.rb#122
  def disable_all; end

  # source://pry-byebug//lib/pry/byebug/breakpoints.rb#136
  def each(&block); end

  # Enables a disabled breakpoint with the given ID.
  #
  # source://pry-byebug//lib/pry/byebug/breakpoints.rb#108
  def enable(id); end

  # @raise [ArgumentError]
  #
  # source://pry-byebug//lib/pry/byebug/breakpoints.rb#144
  def find_by_id(id); end

  # source://pry-byebug//lib/pry/byebug/breakpoints.rb#140
  def last; end

  # source://pry-byebug//lib/pry/byebug/breakpoints.rb#132
  def size; end

  # source://pry-byebug//lib/pry/byebug/breakpoints.rb#128
  def to_a; end

  private

  # source://pry-byebug//lib/pry/byebug/breakpoints.rb#153
  def change_status(id, enabled = T.unsafe(nil)); end

  # source://pry-byebug//lib/pry/byebug/breakpoints.rb#159
  def validate_expression(exp); end
end

# Breakpoint in a file:line location
#
# source://pry-byebug//lib/pry/byebug/breakpoints.rb#16
class Pry::Byebug::Breakpoints::FileBreakpoint < ::SimpleDelegator
  # source://pry-byebug//lib/pry/byebug/breakpoints.rb#17
  def source_code; end

  # source://pry-byebug//lib/pry/byebug/breakpoints.rb#21
  def to_s; end
end

# Breakpoint in a Class#method location
#
# source://pry-byebug//lib/pry/byebug/breakpoints.rb#29
class Pry::Byebug::Breakpoints::MethodBreakpoint < ::SimpleDelegator
  # @return [MethodBreakpoint] a new instance of MethodBreakpoint
  #
  # source://pry-byebug//lib/pry/byebug/breakpoints.rb#30
  def initialize(byebug_bp, method); end

  # source://pry-byebug//lib/pry/byebug/breakpoints.rb#35
  def source_code; end

  # source://pry-byebug//lib/pry/byebug/breakpoints.rb#39
  def to_s; end
end

class Pry::REPL
  extend ::Forwardable

  class << self
    # source://pry-byebug//lib/pry-byebug/pry_ext.rb#19
    def start(options = T.unsafe(nil)); end

    # source://pry-byebug//lib/pry-byebug/pry_ext.rb#8
    def start_with_pry_byebug(options = T.unsafe(nil)); end

    # source://pry-byebug//lib/pry-byebug/pry_ext.rb#6
    def start_without_pry_byebug(options); end
  end
end

# Main container module for Pry-Byebug functionality
#
# source://pry-byebug//lib/pry-byebug/helpers/location.rb#3
module PryByebug
  # Reference to currently running pry-remote server. Used by the processor.
  #
  # source://pry-byebug//lib/pry-byebug/base.rb#10
  def current_remote_server; end

  # Reference to currently running pry-remote server. Used by the processor.
  #
  # source://pry-byebug//lib/pry-byebug/base.rb#10
  def current_remote_server=(_arg0); end

  private

  # Ensures that a command is executed in a local file context.
  #
  # source://pry-byebug//lib/pry-byebug/base.rb#25
  def check_file_context(target, msg = T.unsafe(nil)); end

  # Checks that a target binding is in a local file context.
  #
  # source://pry-byebug//lib/pry-byebug/base.rb#17
  def file_context?(target); end

  class << self
    # Ensures that a command is executed in a local file context.
    #
    # @raise [Pry::CommandError]
    #
    # source://pry-byebug//lib/pry-byebug/base.rb#25
    def check_file_context(target, msg = T.unsafe(nil)); end

    # Checks that a target binding is in a local file context.
    #
    # @return [Boolean]
    #
    # source://pry-byebug//lib/pry-byebug/base.rb#17
    def file_context?(target); end
  end
end

# Display the current stack
#
# source://pry-byebug//lib/pry-byebug/commands/backtrace.rb#9
class PryByebug::BacktraceCommand < ::Pry::ClassCommand
  include ::PryByebug::Helpers::Navigation

  # source://pry-byebug//lib/pry-byebug/commands/backtrace.rb#23
  def process; end
end

# Add, show and remove breakpoints
#
# source://pry-byebug//lib/pry-byebug/commands/breakpoint.rb#12
class PryByebug::BreakCommand < ::Pry::ClassCommand
  include ::PryByebug::Helpers::Breakpoints
  include ::PryByebug::Helpers::Location
  include ::PryByebug::Helpers::Multiline

  # source://pry-byebug//lib/pry-byebug/commands/breakpoint.rb#50
  def options(opt); end

  # source://pry-byebug//lib/pry-byebug/commands/breakpoint.rb#62
  def process; end

  private

  # source://pry-byebug//lib/pry-byebug/commands/breakpoint.rb#111
  def add_breakpoint(place, condition); end

  # source://pry-byebug//lib/pry-byebug/commands/breakpoint.rb#93
  def new_breakpoint; end

  # source://pry-byebug//lib/pry-byebug/commands/breakpoint.rb#102
  def option_to_method(option); end

  # source://pry-byebug//lib/pry-byebug/commands/breakpoint.rb#106
  def print_all; end

  # source://pry-byebug//lib/pry-byebug/commands/breakpoint.rb#88
  def process_condition; end

  # source://pry-byebug//lib/pry-byebug/commands/breakpoint.rb#78
  def process_delete; end

  # source://pry-byebug//lib/pry-byebug/commands/breakpoint.rb#78
  def process_delete_all; end

  # source://pry-byebug//lib/pry-byebug/commands/breakpoint.rb#78
  def process_disable; end

  # source://pry-byebug//lib/pry-byebug/commands/breakpoint.rb#78
  def process_disable_all; end

  # source://pry-byebug//lib/pry-byebug/commands/breakpoint.rb#78
  def process_enable; end

  # source://pry-byebug//lib/pry-byebug/commands/breakpoint.rb#84
  def process_show; end
end

# Continue program execution until the next breakpoint
#
# source://pry-byebug//lib/pry-byebug/commands/continue.rb#11
class PryByebug::ContinueCommand < ::Pry::ClassCommand
  include ::PryByebug::Helpers::Navigation
  include ::PryByebug::Helpers::Breakpoints
  include ::PryByebug::Helpers::Location

  # source://pry-byebug//lib/pry-byebug/commands/continue.rb#31
  def process; end
end

# Travel down the frame stack
#
# source://pry-byebug//lib/pry-byebug/commands/down.rb#9
class PryByebug::DownCommand < ::Pry::ClassCommand
  include ::PryByebug::Helpers::Navigation

  # source://pry-byebug//lib/pry-byebug/commands/down.rb#27
  def process; end
end

# Exit pry REPL with Byebug.stop
#
# source://pry-byebug//lib/pry-byebug/commands/exit_all.rb#9
class PryByebug::ExitAllCommand < ::Pry::Command::ExitAll
  # source://pry-byebug//lib/pry-byebug/commands/exit_all.rb#10
  def process; end
end

# Run until the end of current frame
#
# source://pry-byebug//lib/pry-byebug/commands/finish.rb#9
class PryByebug::FinishCommand < ::Pry::ClassCommand
  include ::PryByebug::Helpers::Navigation

  # source://pry-byebug//lib/pry-byebug/commands/finish.rb#20
  def process; end
end

# Move to a specific frame in the callstack
#
# source://pry-byebug//lib/pry-byebug/commands/frame.rb#9
class PryByebug::FrameCommand < ::Pry::ClassCommand
  include ::PryByebug::Helpers::Navigation

  # source://pry-byebug//lib/pry-byebug/commands/frame.rb#27
  def process; end
end

# source://pry-byebug//lib/pry-byebug/helpers/location.rb#4
module PryByebug::Helpers; end

# Common helpers for breakpoint related commands
#
# source://pry-byebug//lib/pry-byebug/helpers/breakpoints.rb#10
module PryByebug::Helpers::Breakpoints
  # Prints a message with bold font.
  #
  # source://pry-byebug//lib/pry-byebug/helpers/breakpoints.rb#21
  def bold_puts(msg); end

  # Byebug's array of breakpoints.
  #
  # source://pry-byebug//lib/pry-byebug/helpers/breakpoints.rb#14
  def breakpoints; end

  # Max width of breakpoints id column
  #
  # source://pry-byebug//lib/pry-byebug/helpers/breakpoints.rb#77
  def max_width; end

  # Prints a header for the breakpoint list.
  #
  # source://pry-byebug//lib/pry-byebug/helpers/breakpoints.rb#63
  def print_breakpoints_header; end

  # Print out full information about a breakpoint.
  #
  # Includes surrounding code at that point.
  #
  # source://pry-byebug//lib/pry-byebug/helpers/breakpoints.rb#30
  def print_full_breakpoint(breakpoint); end

  # Print out concise information about a breakpoint.
  #
  # source://pry-byebug//lib/pry-byebug/helpers/breakpoints.rb#52
  def print_short_breakpoint(breakpoint); end
end

# Compatibility helper to handle source location
#
# source://pry-byebug//lib/pry-byebug/helpers/location.rb#8
module PryByebug::Helpers::Location
  private

  # Current file in the target binding. Used as the default breakpoint
  # location.
  #
  # source://pry-byebug//lib/pry-byebug/helpers/location.rb#15
  def current_file(source = T.unsafe(nil)); end

  class << self
    # Current file in the target binding. Used as the default breakpoint
    # location.
    #
    # source://pry-byebug//lib/pry-byebug/helpers/location.rb#15
    def current_file(source = T.unsafe(nil)); end
  end
end

# Helpers to help handling multiline inputs
#
# source://pry-byebug//lib/pry-byebug/helpers/multiline.rb#8
module PryByebug::Helpers::Multiline
  # Returns true if we are in a multiline context and, as a side effect,
  # updates the partial evaluation string with the current input.
  #
  # Returns false otherwise
  #
  # source://pry-byebug//lib/pry-byebug/helpers/multiline.rb#15
  def check_multiline_context; end
end

# Helpers to aid breaking out of the REPL loop
#
# source://pry-byebug//lib/pry-byebug/helpers/navigation.rb#8
module PryByebug::Helpers::Navigation
  # Breaks out of the REPL loop and signals tracer
  #
  # source://pry-byebug//lib/pry-byebug/helpers/navigation.rb#12
  def breakout_navigation(action, options = T.unsafe(nil)); end
end

# Run a number of lines and then stop again
#
# source://pry-byebug//lib/pry-byebug/commands/next.rb#10
class PryByebug::NextCommand < ::Pry::ClassCommand
  include ::PryByebug::Helpers::Navigation
  include ::PryByebug::Helpers::Multiline

  # source://pry-byebug//lib/pry-byebug/commands/next.rb#29
  def process; end
end

# Run a number of Ruby statements and then stop again
#
# source://pry-byebug//lib/pry-byebug/commands/step.rb#9
class PryByebug::StepCommand < ::Pry::ClassCommand
  include ::PryByebug::Helpers::Navigation

  # source://pry-byebug//lib/pry-byebug/commands/step.rb#26
  def process; end
end

# Travel up the frame stack
#
# source://pry-byebug//lib/pry-byebug/commands/up.rb#9
class PryByebug::UpCommand < ::Pry::ClassCommand
  include ::PryByebug::Helpers::Navigation

  # source://pry-byebug//lib/pry-byebug/commands/up.rb#27
  def process; end
end
