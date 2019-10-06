class TweetsController < ApplicationController
  before_action :login_required

  def index
    parameters = Parameter.new(params).define_params
    @tweets = Tweet.search(current_user.id, parameters).page(params[:page]).per(30)
  end

  def edit
    @tweet = current_user.tweets.find(params[:id])
    @categories = current_user.categories
  end

  def update
    @relationship = Relationship.new(tweet_id: params[:tweet_id], category_id: params[:category_id])
    @category = Category.find(params[:category_id]).name
    respond_to do |format|
      if @relationship.save
        format.js {@status = 'success'}
      else
        format.js {@status = 'fail'}
      end
    end
  end

  def toggle_status
    tweet = Tweet.find_by(id: params[:id])
    tweet.toggle_clip!
    respond_to do |format|
      format.json {render json: {status: tweet.status}}
    end
  end

end
