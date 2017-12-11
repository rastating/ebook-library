module EPUBInfo
  module Models
    class Cover
      # A monkey patch to fix the broken cover detection functionality
      # in epubinfo 0.4.4. https://github.com/rastating/epubinfo/commit/079dde2e48c28f05256d67e0a2afe7b2b1bae6b7
      def epub_cover_item
        @epub_cover_item ||= begin
          metadata = @parser.metadata_document.css('metadata')
          cover_id = (metadata.css('meta[name=cover]').attr('content').value rescue nil) || 'cover-image'

          manifest = @parser.metadata_document.css('manifest')

          (manifest.css("item[id = \"#{cover_id}\"]").first rescue nil) ||
            (manifest.css("item[properties = \"#{cover_id}\"]").first rescue nil) ||
            (manifest.css("item[property = \"#{cover_id}\"]").first rescue nil) ||
            (manifest.css("item[id = img-bookcover-jpeg]").first rescue nil)
        end
      end
    end
  end
end
