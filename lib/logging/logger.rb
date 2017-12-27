module EBL
  # A logger used for consistently outputting to the CLI and log files.
  class Logger
    VALID_COLOUR_CODES = %i[
      black red green yellow blue magenta cyan white
      light_black light_red light_green light_yellow
      light_blue light_cyan light_white
    ].freeze

    # Create a new instance of #{Logger}.
    def initialize() end

    # Log a message to the CLI and active log file(s).
    # @param message [String] the message to log.
    # @param colour [Symbol] the colour of the tag, `:black`, `:red`,
    #   `:green`, `:yellow`, `:blue`, `:magenta`, `:cyan`, `:white`,
    #   `:light_black`, `:light_red`, `:light_green`, `:light_yellow`,
    #   `:light_blue`, `:light_cyan` or `:light_white`.
    # @return [String] the output that was logged.
    def log(message, colour = :light_white)
      unless VALID_COLOUR_CODES.include?(colour)
        raise "Unknown colour code: #{colour}"
      end

      output = message.send(colour)

      if !context.nil? && !context.empty?
        tag = "[#{context}]".send(colour)
        output = "#{tag} #{message}"
      end

      puts output unless ENV['RACK_ENV'] == 'test'
      output
    end

    # @return [String] the context tag to use in all logged messages.
    attr_accessor :context
  end
end
