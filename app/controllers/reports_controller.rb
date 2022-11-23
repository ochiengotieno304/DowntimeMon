class ReportsController < ApplicationController
  before_action :authenticate_user!

  def index
    @reports = Report.all
  end

  def create
    @service = Service.find(params[:service_id])
    @report = @service.reports.create(params[:report].permit(:maintainer, :reason))
    redirect_to maintenance_action_path(@service)
  end

  def destroy
    @service = Service.find(params[:service_id])
    @report = @report.find(params[:id])
    @report.destroy
    redirect_to maintenance_action_path(@service)
  end
end
