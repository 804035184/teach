class AutoTestProjectsController < ApplicationController
  def show
  end

  def feedback
    respond_to do |format|
      format.json do
        feedback = params[:feedback]
        test_record = get_test_record
        test_record.feedback = feedback
        test_record.save
        render json: {status: 'success'}
      end
    end
  end

  def trigger
    respond_to do |format|
      format.json do
        test_record = get_test_record
        action = params[:trigger]
        if action == 'start'
          gitlab_username = test_record.user.username
          pipeline = create_pipeline test_record.project_id, gitlab_username
          test_record.pipeline_id = pipeline['id']
          test_record.save
        elsif action == 'cancel'
          cancel_pipeline test_record.project_id, test_record.pipeline_id
          test_record.pipeline_id = nil
          test_record.save
        end
        render json: {status: 'success'}
      end
    end
  end

  private

  def create_pipeline(project_id, gitlab_username)
    pipeline = {
      ref: 'master',
      variables: [
        {
          # predefined CI 变量改为该项目 owner
          key: 'GITLAB_USER_LOGIN',
          value: gitlab_username
        }
      ]
    }
    admin_api_post "projects/#{project_id}/pipeline", pipeline
  end

  def cancel_pipeline(project_id, pipeline_id)
    if pipeline_id
      admin_api_post "projects/#{project_id}/pipelines/#{pipeline_id}/cancel", {}
      admin_api_delete "projects/#{project_id}/pipelines/#{pipeline_id}"
    end
  end

  def get_test_record
    auto_test_project = AutoTestProject.find(params[:id])
    auto_test_project.student_test_records.find(params[:test_record_id])
  end
end
