module Api
  module V1
    module Shows
      class EpisodesController < BaseController
        def index
          render jsonapi: episodes.page(page_number).per(page_size)
        end

        private

        def episodes
          show.episodes.with_episode_states_for(user: current_user).with_and_ordered_by_season
        end

        def show
          Show.find_by!(slug: params[:show_slug])
        end
      end
    end
  end
end
