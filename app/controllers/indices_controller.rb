# frozen_string_literal: true

class IndicesController < ApplicationController # rubocop:disable Style/Documentation
  def index
    state = Client.cluster.state
    indices = state['metadata']['indices'].keys
    render json: indices
  end

  def create # rubocop:disable Metrics/MethodLength
    index = Client.index(params[:name])

    if index.exists?
      render json: { message: 'Index already exists' }, status: :conflict
    else
      index.create(
        settings: { 'index.number_of_shards' => 3 },
        mappings: {
          _source: { enabled: true },
          properties: {
            author: { type: 'keyword' },
            title: { type: 'text' }
          }
        }
      )
      render json: { message: 'Index created successfully' }
    end
  end

  def destroy
    Client.index(params[:name]).delete
    render json: { message: 'Index deleted successfully' }
  end

  def show
    index = Client.index(params[:name])
    render json: { name: params[:name], exists: index.exists? }
  end
end
