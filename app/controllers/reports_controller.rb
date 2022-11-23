class ReportsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_service, only: %i[create destroy show]
  before_action :set_report, only: %i[show destroy]

  def index
    @reports = Report.all
  end

  def show; end

  def create
    @report = @service.reports.create(report_params)
    redirect_to maintenance_action_path(@service)
  end

  def destroy
    @report.destroy
    redirect_to maintenance_action_path(@service)
  end

  private

  def report_params
    params.require(:report).permit(:maintainer, :reason, :duration)
  end

  def set_service
    @service = Service.find(params[:service_id])
  end

  def set_report
    @report = Report.find(params[:id])
  end
end
