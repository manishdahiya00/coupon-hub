module API
  module V1
    class Appuser < Grape::API
      include API::V1::Defaults

      resource :home do
        before { api_params }

        params do
          use :common_params
        end

        post do
          begin
            user = valid_user(params[:userId], params[:securityToken])
            if user.present?
              appBanners = []
              topCategories = []
              topStores = []
              specialOffer = {}
              topOffers = []
              CouponCategory.active.each do |category|
                topCategories << {
                  id: category.id,
                  title: category.name,
                  image: category.img_url,
                }
              end
              CouponStore.active.each do |store|
                topStores << {
                  id: store.id,
                  image: store.img_url,
                  title: store.name,
                  subtitle: store.cashback,
                  status: "Activate Cashback",
                }
              end
              CouponOffer.active.each do |offer|
                appBanners << {
                  id: offer.id,
                  image: offer.img_url,
                }
                specialOffer = {
                  id: offer.id,
                  image: offer.img_url,
                }
                topOffers << {
                  id: offer.id,
                  title: offer.name,
                  image: offer.img_url,
                  cashback: offer.payout_cashback,
                  desc: offer.short_desc,
                  category: offer.coupon_category.name,
                  users: [1500, 2798, 4263, 7564, 76412, 82164, 1600, 7324, 9896, 9410, 4315].sample.to_s,
                  success: "#{[52, 65, 78, 95, 84, 75, 63, 99, 100, 88, 69].sample.to_s}%",
                }
              end
              res = { status: 200, message: MSG_SUCCESS, appBanners: appBanners || [], topCategories: topCategories || [], topStores: topStores || [], specialOffer: specialOffer || {}, topOffers: topOffers || [] }
              LogsHelper.logs(res, request)
              return res
            else
              res = { status: 500, message: "User Not Found" }
              LogsHelper.logs(res, request)
              return res
            end
          rescue Exception => e
            log = "API Exception - #{Time.now} - home - #{params.inspect} - Error - #{e}"
            Rails.logger.info log
            LogsHelper.logs(log, request)
            { status: 200, message: MSG_ERROR, error: e }
          end
        end
      end

      resource :categories do
        before { api_params }

        params do
          use :common_params
        end

        post do
          begin
            user = valid_user(params[:userId], params[:securityToken])
            if user.present?
              categories = []
              CouponCategory.active.each do |category|
                cashback = [50, 82, 96, 43, 63, 80].sample
                categories << {
                  id: category.id,
                  title: category.name,
                  image: category.img_url,
                  totalOffers: category.coupon_offers.count.to_s,
                  cashback: "#{cashback}% Off",
                }
              end
              res = { status: 200, message: MSG_SUCCESS, categories: categories || [] }
              LogsHelper.logs(res, request)
              return res
            else
              res = { status: 500, message: "User Not Found" }
              LogsHelper.logs(res, request)
              return res
            end
          rescue Exception => e
            log = "API Exception - #{Time.now} - categories - #{params.inspect} - Error - #{e}"
            Rails.logger.info log
            LogsHelper.logs(log, request)
            { status: 200, message: MSG_ERROR, error: e }
          end
        end
      end

      resource :offerDetail do
        before { api_params }

        params do
          use :common_params
          requires :offerId, type: String, allow_blank: false
        end

        post do
          begin
            user = valid_user(params[:userId], params[:securityToken])
            if user.present?
              offerDetail = CouponOffer.find_by(id: params[:offerId])
              if offerDetail.present?
                offerDetail = {
                  image: offerDetail.img_url,
                  title: offerDetail.name,
                  category: offerDetail.coupon_category.name,
                  desc: offerDetail.short_desc,
                  cashback: offerDetail.payout_cashback,
                  steps: offerDetail.long_desc,
                  users: [1500, 2798, 4263, 7564, 76412, 82164, 1600, 7324, 9896, 9410, 4315].sample.to_s,
                  success: "#{[52, 65, 78, 95, 84, 75, 63, 99, 100, 88, 69].sample.to_s}%",
                  minOrder: [50, 100, 150, 200, 250, 300, 350, 400, 450, 500].sample.to_s,
                  maxCashback: [500, 550, 600, 650, 700, 750, 800, 850, 900, 950, 1000].sample.to_s,
                  saleTrack: [12, 18, 3, 6, 7, 19, 25, 30].sample.to_s,
                  confirmedBy: [112, 118, 53, 86, 97, 109, 52, 80].sample.to_s,
                  shareUrl: "www.google.com",
                  shopUrl: "www.google.com",
                }
                res = { status: 200, message: MSG_SUCCESS, offerDetails: offerDetail || {} }
                LogsHelper.logs(res, request)
                return res
              else
                res = { status: 500, message: "Offer Not Found" }
                LogsHelper.logs(res, request)
                return res
              end
            else
              res = { status: 500, message: "User Not Found" }
              LogsHelper.logs(res, request)
              return res
            end
          rescue Exception => e
            log = "API Exception - #{Time.now} - offerDetail - #{params.inspect} - Error - #{e}"
            Rails.logger.info log
            LogsHelper.logs(log, request)
            { status: 200, message: MSG_ERROR, error: e }
          end
        end
      end

      resource :categoryOffers do
        before { api_params }

        params do
          use :common_params
          requires :categoryId, type: String, allow_blank: false
        end

        post do
          begin
            user = valid_user(params[:userId], params[:securityToken])
            if user.present?
              category = CouponCategory.find_by(id: params[:categoryId])
              if category.present?
                categoryOffers = []
                offers = category.coupon_offers.active
                offers.each do |offer|
                  categoryOffers << {
                    image: offer.img_url,
                    cashback: offer.payout_cashback,
                    title: offer.name,
                    category: offer.coupon_category.name,
                    description: offer.short_desc,
                  }
                end
                res = { status: 200, message: MSG_SUCCESS, categoryOffers: categoryOffers || {} }
                LogsHelper.logs(res, request)
                return res
              else
                res = { status: 500, message: "Category Not Found" }
                LogsHelper.logs(res, request)
                return res
              end
            else
              res = { status: 500, message: "User Not Found" }
              LogsHelper.logs(res, request)
              return res
            end
          rescue Exception => e
            log = "API Exception - #{Time.now} - offerDetail - #{params.inspect} - Error - #{e}"
            Rails.logger.info log
            LogsHelper.logs(log, request)
            { status: 200, message: MSG_ERROR, error: e }
          end
        end
      end

      resource :storesList do
        before { api_params }

        params do
          use :common_params
        end

        post do
          begin
            user = valid_user(params[:userId], params[:securityToken])
            if user.present?
              couponStores = []
              stores = CouponStore.active
              stores.each do |store|
                couponStores << {
                  image: store.img_url,
                  title: store.name,
                  desc: store.cashback,
                  status: "Activate Cashback",
                }
              end
              res = { status: 200, message: MSG_SUCCESS, stores: couponStores || [] }
              LogsHelper.logs(res, request)
              return res
            else
              res = { status: 500, message: "User Not Found" }
              LogsHelper.logs(res, request)
              return res
            end
          rescue Exception => e
            log = "API Exception - #{Time.now} - storesList - #{params.inspect} - Error - #{e}"
            Rails.logger.info log
            LogsHelper.logs(log, request)
            { status: 200, message: MSG_ERROR, error: e }
          end
        end
      end

      resource :storeDetail do
        before { api_params }

        params do
          use :common_params
          requires :storeId, type: String, allow_blank: false
        end

        post do
          begin
            user = valid_user(params[:userId], params[:securityToken])
            if user.present?
              storeDetail = CouponStore.find_by(id: params[:storeId])
              if storeDetail.present?
                offers = []
                storeDetail.coupon_offers.active.each do |offer|
                  offers << {
                    id: offer.id,
                    cashback: offer.payout_cashback,
                    desc: offer.short_desc,
                    users: [1500, 2798, 4263, 7564, 76412, 82164, 1600, 7324, 9896, 9410, 4315].sample.to_s,
                    success: "#{[52, 65, 78, 95, 84, 75, 63, 99, 100, 88, 69].sample.to_s}%",
                  }
                end
                storeDetails = {
                  image: storeDetail.img_url,
                  title: storeDetail.name,
                  shareUrl: "www.google.com",
                  cashback: storeDetail.cashback,
                  trackTime: "24 hours",
                  offers: offers,
                }
                res = { status: 200, message: MSG_SUCCESS, storeDetails: storeDetails || {} }
                LogsHelper.logs(res, request)
                return res
              else
                res = { status: 500, message: "Store Not Found" }
                LogsHelper.logs(res, request)
                return res
              end
            else
              res = { status: 500, message: "User Not Found" }
              LogsHelper.logs(res, request)
              return res
            end
          rescue Exception => e
            log = "API Exception - #{Time.now} - storeDetail - #{params.inspect} - Error - #{e}"
            Rails.logger.info log
            LogsHelper.logs(log, request)
            { status: 200, message: MSG_ERROR, error: e }
          end
        end
      end
    end
  end
end
