class SneakersController < ApplicationController
  before_action :set_sneaker, only: %i[ show edit update destroy ]

  # 👇 exige login para todo excepto catálogo y ficha
  before_action :authenticate_user!, except: %i[index show]

  # 👇 solo admins pueden crear/editar/borrar
  before_action :require_admin, only: %i[new create edit update destroy]

  # GET /sneakers
  def index
    @sneakers = Sneaker.where(published: true).order(created_at: :desc)
  end

  # GET /sneakers/1
  def show; end

  # GET /sneakers/new
  def new
    @sneaker = Sneaker.new
  end

  # GET /sneakers/1/edit
  def edit; end

  # POST /sneakers
  def create
    @sneaker = Sneaker.new(sneaker_params)
    respond_to do |format|
      if @sneaker.save
        format.html { redirect_to @sneaker, notice: "Sneaker was successfully created." }
        format.json { render :show, status: :created, location: @sneaker }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @sneaker.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sneakers/1
  def update
    respond_to do |format|
      if @sneaker.update(sneaker_params)
        format.html { redirect_to @sneaker, notice: "Sneaker was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @sneaker }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @sneaker.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sneakers/1
  def destroy
    @sneaker.destroy!
    respond_to do |format|
      format.html { redirect_to sneakers_path, notice: "Sneaker was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private

  def set_sneaker
    @sneaker = Sneaker.find(params[:id])  # si usas friendly_id: Sneaker.friendly.find(params[:id])
  end

  def sneaker_params
    params.require(:sneaker).permit(
      :brand, :model, :colorway, :size, :sku,
      :price_cents, :currency, :description,
      :condition, :stock, :published, :slug,
      images: []
    )
  end

  # 🔐 Solo admins
  def require_admin
    unless current_user&.admin?
      redirect_to root_path, alert: "No tienes permisos para acceder aquí."
    end
  end
end
