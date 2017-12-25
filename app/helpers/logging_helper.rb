module EBL
  module Helpers
    # A helper module containing methods for writing to a logger.
    module LoggingHelper
      def setup_logger(context)
        self.logger = EBL::Logger.new
        logger.context = context
      end

      def log_error(message)
        logger.log message, :red
      end

      def log_green(message)
        logger.log message, :green
      end

      attr_accessor :logger
    end
  end
end
