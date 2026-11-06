# frozen_string_literal: true

module Admin
  class ServicesController < ApplicationController
    def index
      authorize Service
      @services = policy_scope(Service).order(:name)
    end

    def new
      @service = Service.new
      authorize @service
    end

    def create
      @service = Service.new(service_params)
      authorize @service

      if @service.save
        redirect_to admin_services_path, notice: "Service was successfully created."
      else
        render :new, status: :unprocessable_content
      end
    end

    def edit
      @service = Service.find(params[:id])
      authorize @service
    end

    def update
      @service = Service.find(params[:id])
      authorize @service

      if @service.update(service_params)
        redirect_to admin_services_path, notice: "Service was successfully updated."
      else
        render :edit, status: :unprocessable_content
      end
    end

    private

    def service_params
      params.require(:service).permit(:name, :duration_minutes, :price, :active)
    end
  end
end
