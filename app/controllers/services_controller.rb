class ServicesController < ApplicationController
  before_action :set_service, only: %i[show edit update destroy maintenance_report]
  before_action :authenticate_user!
  before_action :correct_user, only: %i[edit update destroy]

  # GET /services or /services.json
  def index
    @services = Service.all
  end

  # GET /services/1 or /services/1.json
  def show
    @piechartdata = Service.pluck(:status_history)
    @data = @service.status_history
    @unique_status = @service.status_history.uniq.compact
    @status_history_tally = @service.status_history.compact.tally
  end

  # GET /services/new
  def new
    @service = current_user.services.build
  end

  # GET /services/1/edit
  def edit; end

  # POST /services or /services.json
  def create
    @service = current_user.services.build(service_params)

    respond_to do |format|
      if @service.save
        ServiceMailer.with(service: @service).new_service_email(current_user).deliver_later
        format.html { redirect_to service_url(@service), notice: 'Service was successfully created.' }
        format.json { render :show, status: :created, location: @service }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @service.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /services/1 or /services/1.json
  def update
    respond_to do |format|
      if @service.update(service_params)
        format.html { redirect_to service_url(@service), notice: 'Service was successfully updated.' }
        format.json { render :show, status: :ok, location: @service }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @service.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /services/1 or /services/1.json
  def destroy
    @service.destroy

    respond_to do |format|
      format.html { redirect_to services_url, notice: 'Service was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  def correct_user
    @service = current_user.services.find_by(id: params[:id])
    redirect_to services_path, notice: 'Not Authorized To Edit This Service' if @service.nil?
  end

  def maintenance_report
    @recommended_maintenance_date = Service.generate_report(@service.interval, @service.status_history, @service.last_down)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_service
    @service = Service.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def service_params
    params.require(:service).permit(:name, :endpoint, :status, :interval)
  end
end
