module Admin
  class SneakersController < ApplicationController
    before_action :set_sneaker, only: [ :edit, :update, :destroy, :toggle_publish ]

    # http_basic_authenticate_with name: ENV["ADMIN_USER"], password: ENV["ADMIN_PASS"] # opcional

    def index
      @sneakers = Sneaker.order(created_at: :desc)
    end

    def edit; end

    def update
      if @sneaker.update(sneaker_params)
        redirect_to admin_sneakers_path, notice: "Actualizada."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @sneaker.destroy!
      redirect_to admin_sneakers_path, notice: "Eliminada."
    end

    def toggle_publish
      @sneaker.update!(published: !@sneaker.published)
      redirect_to admin_sneakers_path, notice: "Estado cambiado a #{@sneaker.published ? "Publicado" : "Oculto"}."
    end

    private

    def set_sneaker
      @sneaker = Sneaker.find(params[:id])
    end

    def sneaker_params   # 👈 corregido (antes tenías sneaker_paramsa)
      params.require(:sneaker).permit(
        :brand, :model, :colorway, :size, :sku,
        :price_cents, :currency, :description,
        :condition, :stock, :published, :slug,
        images: []
      )
    end
  end
end
