class Api::V1::CountriesController < ApiController
  # 地点登録されている国一覧を取得
  def index
    iso = []
    areas = []
    areas_name = []
    countries = Country.all
    countries.each do |country|
      # 地点を一つでも含んだ国のみを取得
      if country.spots.present?
        iso << country.iso.downcase
        areas << country
      end
      # DB内にあるすべての国の名前を取得
      areas_name << country.name
    end
    render json: {areas: areas, iso: iso, areas_name: areas_name }
  end

  # 国IDから国に関する地点情報を取得
  def show
    country = Country.find(params[:id])
    spots = country.spots
    if spots.present?
      render json: { area: country, spots: spots }
    else
      render json: country, status: :bad_request
    end
  end

  # 国コード(iso)で判別し国を取得
  def set_country
    country = Country.find_by(iso: params[:iso])
    spots = Spot.find_by(country_id: country.id)

    # 地点登録されている国をjsonで返す
    if spots.present?
      render json: country
    else
      render json: country, status: :bad_request
    end
  end
end
