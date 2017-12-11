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
    def log(message, colour = :light_white)
      unless VALID_COLOUR_CODES.include?(colour)
        raise "Unknown colour code: #{colour}"
      end

      if context.nil? || context.empty?
        puts message.send(colour)
      else
        tag = "[#{context}]".send(colour)
        puts "#{tag} #{message}"
      end
    end

    # @return [String] the context tag to use in all logged messages.
    attr_accessor :context
  end
end
