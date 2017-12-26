module EBL
  module Jobs
    # A background job that will refresh the metadata of
    # an EBL book entry, using the latest data from the file.
    class RefreshMetadataJob
      include SuckerPunch::Job

      def perform(book_id)
        # Check sha1 hash of book to see if data has chaned on disk since last
        # refresh, if forced refresh isn't being done
        puts "Refresh metadata for: #{book_id}"
      end
    end
  end
end
