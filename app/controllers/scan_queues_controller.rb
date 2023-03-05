# frozen_string_literal: true

class ScanQueuesController < ApplicationController
  before_action :authenticate_owner!

  # index: shows the full scan queue
  def index
    @scan_results = ScanQueue.where(owner: current_owner)
  end
  # show: shows one entry in the scan queue
  def show
    1+1
  end
  # new: shows the scan form
  def new
    @scan_results = ScanQueue.where(owner: current_owner)
  end

  # create: creates an entry in scan queue
  def create
    1+1
  end

  # destroy: removes an item from the scan queue
  def destroy
    1+1
  end
end
