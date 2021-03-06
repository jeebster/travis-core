module Travis
  module Api
    module Json
      module Webhook
        class Build
          autoload :Finished, 'travis/api/json/webhook/build/finished'

          attr_reader :build, :commit, :request, :repository

          def initialize(build)
            @build = build
            @commit = build.commit
            @request = build.request
            @repository = build.repository
          end
        end
      end
    end
  end
end


