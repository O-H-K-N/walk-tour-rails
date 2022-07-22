class Api::V1::SpotsController < ApiController
  # 国に紐づくスポット一覧を返す
  def index
    spots = Spot.all.order(created_at: :desc)
    response = []
    spots.each do |spot|
      # videoを保有している地点のみ有効
      if Video.where(spot: spot.name) != []
        ramdam_data = Video.where(spot: spot.name).order("RANDOM()").first
        response<< {
          spot: spot,
          area: spot.country,
          video: {
            video_id: ramdam_data.video_id,
            title: ramdam_data.title,
            thumbnail: ramdam_data.thumbnail,
            view_count: ramdam_data.view_count.to_s(:delimited),
            published_at: ramdam_data.published_at.strftime("%Y/%m/%d")
          },
          created_at: spot.created_at,
          click_count: spot.click_count
        }
      end
    end
    render json: { ranking: response, create: response.select{|a| a[:spot].recently?} }
  end

  # 地点のカウント数(click_count)を+1する
  def edit
    spot = Spot.find_by(country_id: params[:country_id], id: params[:id])
    spot.update(click_count: spot.click_count + 1)
    render json: { status: 'ok' }
  end
end
