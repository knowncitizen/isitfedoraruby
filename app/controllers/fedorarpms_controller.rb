class FedorarpmsController < ApplicationController

  helper_method :sort_column, :sort_direction

  def index
    @page_title = 'Fedora Rpms'
    @rpms = FedoraRpm.paginate(:page => params[:page], :per_page => 50).order(sort_column + " " + sort_direction)
  end

  def show
    @name = params[:id]
    @rpm = FedoraRpm.find_by_name(@name, :include => :rpm_comments)
    @page_title = @rpm.name
    @dependencies = @rpm.dependency_packages
    @dependents = @rpm.dependent_packages
  end

  def full_deps
    @name = params[:id]
    @rpm = FedoraRpm.find_by_name(@name)
    respond_to do |format|
      format.html
    end
  end

  def full_dependencies
    @name = params[:id]
    @rpm = FedoraRpm.find_by_name(@name)
    respond_to do |format|
      format.json { render :json => @rpm.json_dependencies }
    end
  end

  def full_dependents
    @name = params[:id]
    @rpm = FedoraRpm.find_by_name(@name)
    respond_to do |format|
      format.json { render :json => @rpm.json_dependents }
    end
  end

private

  def sort_column
    %w[name commits last_commit_date].include?(params[:sort]) ? params[:sort] : "name"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

end
