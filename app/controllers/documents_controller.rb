# require 'elastomer/client'
# ElastomerClient = Elastomer::Client.new
class DocumentsController < ApplicationController
  def create
    ElastomerClient.index(params[:index_name]).document(params[:type]).index(params[:document], id: params[:id])
    render json: { message: 'Document created successfully' }
  end

  def destroy
    ElastomerClient.index(params[:index_name]).document(params[:type]).delete(id: params[:id])
    render json: { message: 'Document deleted successfully' }
  end

  def show
    document = ElastomerClient.index(params[:index_name]).document(params[:type]).get(id: params[:id])
    render json: document
  end
end
