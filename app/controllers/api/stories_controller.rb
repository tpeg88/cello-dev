module Api
  class StoriesController < ApiController
    def create
      @story = Story.new(story_params)
      @story.requester_id = current_user.id
      
      unless %w(unscheduled unstarted).include?(story_params[:story_state])
        @story.owner_id ||= current_user.id
      end
    
      if @story.save
        @story.project.touch
        render partial: 'api/stories/story', locals: { story: @story }
      else
        render json: { errors: @story.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def update
      @story = Story.find(params[:id])
      
      server_params = {}
      
      unless %w(unscheduled unstarted).include?(story_params[:story_state])
        server_params[:owner_id] = current_user.id unless @story.owner_id
      end
      
      unless story_params[:iteration_id]
        server_params[:iteration_id] = nil
      end
      
      if @story.update_attributes(story_params.merge(server_params))
        @story.project.touch
        render partial: 'api/stories/story', locals: { story: @story }
      else
        render json: { errors: @story.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def show
      @story = Story.find(params[:id])
    
      render partial: 'api/stories/story', locals: { story: @story }
    end

    def index
      @stories = Project.find(params[:project_id]).stories
      render "index"
    end

    def destroy
      @story = Story.find(params[:id])
    
      if @story.requester_id == current_user.id
        @story.destroy
        render partial: 'api/stories/story', locals: { story: @story }
      else
        render json: { errors: ["Unable to destroy story: #{@story.id}"] }, status: :unprocessable_entity
      end
    end
  
    private
    def story_params
      params.require(:story).permit(:id, :title, :description, :story_type,
            :story_state, :story_rank, :story_points, :project_id,
            :iteration_id, :requester_id, :owner_id)
    end
  end
end