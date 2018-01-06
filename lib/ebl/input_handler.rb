require 'readline'
require 'io/console'
require 'fileutils'

module EBL
  # A class that provides a standardised means of gaining input via the terminal.
  class InputHandler
    # Initialise a new {InputHandler}.
    # @param logger [EBL::Logger] the logger used to log validation errors.
    # @return [EBL::InputHandler]
    def initialize(logger)
      self.logger = logger
    end

    # Prompt for a path to a file / directory.
    # @param prompt [String] the prompt to display.
    # @return [String, nil] the path if valid, or nil.
    def get_path(prompt)
      value = Readline.readline(prompt).chomp
      return value.chomp if File.directory?(value)

      logger.log "#{prompt} does not exist"
      nil
    end

    # Prompt for an alphanumeric value.
    # @param entity [String] the entity being acquired.
    # @param min [Integer] the minimum number of characters to accept.
    # @param max [Integer] the maximum number of characters to accept.
    # @return [String, nil] the value if valid, otherwise nil.
    def get_alphanumeric_value(entity, min, max)
      value = Readline.readline("Enter #{entity}: ")

      return value if value =~ /^[a-zA-Z0-9]{#{min},#{max}}$/

      error = "The #{entity} must contain #{min}-#{max} alphanumeric characters"
      logger.log error, :red

      nil
    end

    # Prompt for input with echo disabled.
    # @param prompt [String] the input prompt.
    # @return [String] the input with trailing new lines removed.
    def gets_no_echo(prompt)
      print prompt
      value = STDIN.noecho(&:gets).chomp
      puts
      value
    end

    # Prompt for a password and confirm it.
    # @param min [Integer] the minimum number of characters to accept.
    # @return [String, nil] the password if valid, otherwise nil.
    def get_password(min)
      password = gets_no_echo 'Enter password: '

      if password.length < min
        logger.log "Password must be at least #{min} characters", :red
        return nil
      end

      if password != gets_no_echo('Confirm password: ')
        logger.log 'The passwords entered did not match', :red
        return nil
      end

      password
    end

    attr_accessor :logger
  end
end
