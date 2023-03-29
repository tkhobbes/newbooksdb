# frozen_string_literal: true

class ScanQueuesController < ApplicationController
  before_action :authenticate_owner!

  # index: shows the full scan queue
  def index
    @scan_results = Kredis.set current_owner.id.to_s
  end

  # new: shows the scan form
  def new
    @scan_results = Kredis.set current_owner.id.to_s, typed: :string
  end

  # create: creates an entry in scan queue
  # this method smells of :reek:DuplicateMethodCall
  def create
    @scan_results = Kredis.set current_owner.id.to_s
    @scan_results << params[:isbn] unless @scan_results.include? params[:isbn]

    respond_to do |format|
      format.turbo_stream
    end
  end

  # destroy: removes an item from the scan queue
  # this method smells of :reek:TooManyStatements
  def destroy
    scan_results = Kredis.set current_owner.id.to_s
    @scan_result = params[:id]
    scan_results.remove @scan_result if scan_results.include? @scan_result
    respond_to do |format|
      format.html { redirect_to new_scan_queue_path, notice: 'Scan queue cleared', status: :see_other }
      format.turbo_stream
    end
  end
end
