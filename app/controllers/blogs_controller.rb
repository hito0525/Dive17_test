class BlogsController < ApplicationController
  before_action :set_blog, only: [:show, :edit, :update, :destroy]

  # GET /blogs
  # GET /blogs.json
  def index
    #公開保存のみ？
    #@blogs = Blog.all
    @blogs = Blog.where(status:2)
  end

  #Draft(下書き)
  def draft_index
    @blogs = Blog.where(status:1)
  end


  #in oreder to stay the title when deleted.
  #so meaning,no deleted in DB it's important learn this,
   def deleted_index
    @blogs = Blog.where(status:3)
  end

  # GET /blogs/1
  # GET /blogs/1.json
  def show
  end

  # GET /blogs/new
  def new
    @blog = Blog.new
  end

  # GET /blogs/1/edit
  def edit

  end

  # POST /blogs
  # POST /blogs.json
  def create
    @blog = Blog.new(blog_params)
    if params[:draft]
      @blog.status = 1
    else
      @blog.status = 2
    end

    respond_to do |format|
      if @blog.save
         if params[:draft]
        format.html { redirect_to draft_index_path, notice: 'ブログを下書き（ステータス１へ)' }
      else
        format.html { redirect_to @blog, notice: 'ブログを公開（ステータス２へ投稿成功.）' }
      end
        format.json { render :show, status: :created, location: @blog }
      else
        format.html { render :new }
        format.json { render json: @blog.errors, status: :unprocessable_entity }
      end
    end
  end



  # PATCH/PUT /blogs/1
  # PATCH/PUT /blogs/1.json
  def update
    respond_to do |format|
      @blog.status = 2
      if @blog.update(blog_params)
        format.html { redirect_to @blog, notice: 'Blog was successfully updated.' }
        format.json { render :show, status: :ok, location: @blog }
      else
         @blog.status = 1
        format.html { render :edit }
        format.json { render json: @blog.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /blogs/1
  # DELETE /blogs/1.json
  def destroy
    #DB上では決してはならないため@blog.destroyは封印よ！！！宮下さんからdestory コマンドは消えてしまうためここでは使わないことを授業で理解！！！
    respond_to do |format|

      @blog.status = 3
      @blog.save
      format.html { redirect_to blogs_url, notice: 'Blog was successfully destroyed.Just note that the real thing is just move to Deleted Index' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_blog
      @blog = Blog.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def blog_params
      params.require(:blog).permit(:title, :status)
    end
end
