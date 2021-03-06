module Travis
  module Api
    module Json
      module Http
        class Repositories
          include Formats

          attr_reader :repositories

          def initialize(repositories, options = {})
            @repositories = repositories
          end

          def data
            repositories.map { |repository| repository_data(repository) }
          end

          def repository_data(repository)
            {
              'id' => repository.id,
              'slug' => repository.slug,
              'description' => repository.description,
              'last_build_id' => repository.last_build_id,
              'last_build_number' => repository.last_build_number,
              'last_build_status' => repository.last_build_status,
              'last_build_result' => repository.last_build_status,
              'last_build_duration' => repository.last_build_duration,
              'last_build_language' => repository.last_build_language,
              'last_build_started_at' => format_date(repository.last_build_started_at),
              'last_build_finished_at' => format_date(repository.last_build_finished_at),
              'branch_summary' => branch_summary_data(repository)
            }
          end

          def branch_summary_data(repository)
            repository.last_finished_builds_by_branches.map do |build|
              {
                'build_id' => build.id,
                'commit' => build.commit.commit,
                'branch' => build.commit.branch,
                'message' => build.commit.message,
                'status' => build.status,
                'finished_at' => format_date(build.finished_at),
                'started_at' => format_date(build.started_at)
              }
            end
          end
        end
      end
    end
  end
end
