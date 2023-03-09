# frozen_string_literal: true

class ScanQueuesController < ApplicationController
  before_action :authenticate_owner!

  # index: shows the full scan queue
  def index
    @scan_results = ScanQueue.where(owner: current_owner)
  end

  # new: shows the scan form
  def new
    @scan_results = ScanQueue.where(owner: current_owner)
  end

  # create: creates an entry in scan queue
  def create
    @queue_entry = ScanQueue.find_or_create_by(isbn: params[:isbn], owner: current_owner)
    @scan_results = ScanQueue.where(owner: current_owner)
    respond_to do |format|
      format.turbo_stream
    end
  end

  # destroy: removes an item from the scan queue
  def destroy
    @scan_result = ScanQueue.find(params[:id]).destroy
    respond_to do |format|
      format.html { redirect_to new_scan_queue_path, notice: 'Scan queue cleared', status: :see_other }
      format.turbo_stream
    end
  end
end
