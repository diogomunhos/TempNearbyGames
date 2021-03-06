class DocumentsController < ApplicationController
  before_action :set_document, only: [:show, :edit, :update, :destroy]

  # GET /documents
  # GET /documents.json
  def index
    @documents = Document.all
  end

  # GET /documents/1
  # GET /documents/1.json
  def show
    redirect_to "/temp"
  end

  # GET /documents/new
  def new
    @document = Document.new
  end

  # GET /documents/1/edit
  def edit
  end

  # POST /documents
  # POST /documents.json
  def create
    Advertising.create(is_active: true, position: 1, html_body: '<div style="width: 100%; position: relative; margin-top: 10px;">
    <img src="https://s.dynad.net/stack/4BgnrAZSVmtsYZEoVHY3LVIHRm6n4DYLj_gEGn1ccdE.gif" style="width: 100%;">
  </div>', is_default: true)
    article = Article.create(title: "Dinamic Test", subtitle: "subtitle dinamic test", preview: "this is a preview dinamic test", body: "this is a body for dinamic test", is_highlight: true)
    @document = Document.new(document_params)
    if @document.save
      ArticleDocument.create(article_id: article.id, document_id: @document.id, document_type: "thumb");
    end
    respond_to do |format|
      if @document.save
        format.html { redirect_to @document, notice: 'Document was successfully created.' }
        format.json { render :show, status: :created, location: @document }
      else
        format.html { render :new }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /documents/1
  # PATCH/PUT /documents/1.json
  def update
    respond_to do |format|
      if @document.update(document_params)
        format.html { redirect_to @document, notice: 'Document was successfully updated.' }
        format.json { render :show, status: :ok, location: @document }
      else
        format.html { render :edit }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /documents/1
  # DELETE /documents/1.json
  def destroy
    @document.destroy
    respond_to do |format|
      format.html { redirect_to documents_url, notice: 'Document was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_document
      @document = Document.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def document_params
      params.require(:document).permit(:file)
    end

  end
