module Shows
  class Import
    def initialize(ref:)
      self.ref = ref
    end

    def call
      Show.find_or_initialize_by(thetvdb_ref: ref).tap do |show|
        result  = thetvdb.series(ref)
        posters = result.posters

        show.title    = result.name
        show.slug     = result.slug
        show.image    = "/banners/#{posters.first.fileName}" if posters.any?
        show.overview = result.overview
        show.save!

        Episodes::Import.new(show: show).call
      end
    end

    private

    attr_accessor :ref

    def thetvdb
      @thetvdb ||= TVDB.new(apikey: Rails.application.config.x.thetvdb_apikey)
    end
  end
end
