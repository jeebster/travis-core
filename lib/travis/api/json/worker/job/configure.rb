module Travis
  module Api
    module Json
      module Worker
        class Job
          class Configure < Job
            def data
              {
                'type' => 'configure',
                'build' => build_data,
                'repository' => repository_data,
                'queue' => job.queue
              }
            end

            def build_data
              {
                'id' => job.id,
                'commit' => commit.commit,
                'branch' => commit.branch,
                'config_url' => commit.config_url
              }
            end

            def repository_data
              {
                'id' => repository.id,
                'slug' => repository.slug
              }
            end
          end
        end
      end
    end
  end
end
