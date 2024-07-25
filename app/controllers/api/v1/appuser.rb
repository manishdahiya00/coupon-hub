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
      resource :search do
        before { api_params }

        params do
          use :common_params
          requires :query, type: String, allow_blank: true
        end

        post do
          begin
            user = valid_user(params[:userId], params[:securityToken])
            if user.present?
              data = []
              offers = CouponOffer.where("name LIKE ?", "%#{params[:query]}%")
              offers.each do |offer|
                data << {
                  id: offer.id,
                  image: offer.img_url,
                  cashback: offer.payout_cashback,
                  title: offer.name,
                  category: offer.coupon_category.name,
                  description: offer.short_desc,
                }
              end
              res = { status: 200, message: MSG_SUCCESS, data: data || [] }
              LogsHelper.logs(res, request)
              return res
            else
              res = { status: 500, message: "User Not Found" }
              LogsHelper.logs(res, request)
              return res
            end
          rescue Exception => e
            log = "API Exception - #{Time.now} - search - #{params.inspect} - Error - #{e}"
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
              offerDetail = CouponOffer.active.find_by(id: params[:offerId])
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
                  shareUrl: "#{BASE_URL}/invite/#{params[:userId]}",
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

      resource :offersList do
        before { api_params }

        params do
          use :common_params
          requires :categoryId, type: String, allow_blank: true
        end

        post do
          begin
            user = valid_user(params[:userId], params[:securityToken])
            if user.present?
              if !params[:categoryId].blank?
                category = CouponCategory.active.find_by(id: params[:categoryId])
                if category.present?
                  categoryOffers = []
                  offers = category.coupon_offers.active
                  offers.each do |offer|
                    categoryOffers << {
                      id: offer.id,
                      image: offer.img_url,
                      cashback: offer.payout_cashback,
                      title: offer.name,
                      category: offer.coupon_category.name,
                      description: offer.short_desc,
                    }
                  end
                  res = { status: 200, message: MSG_SUCCESS, categoryOffers: categoryOffers || [] }
                  LogsHelper.logs(res, request)
                  return res
                else
                  res = { status: 500, message: "Category Not Found" }
                  LogsHelper.logs(res, request)
                  return res
                end
              else
                allOffers = []
                offers = CouponOffer.active.all
                offers.each do |offer|
                  allOffers << {
                    id: offer.id,
                    image: offer.img_url,
                    cashback: offer.payout_cashback,
                    title: offer.name,
                    category: offer.coupon_category.name,
                    description: offer.short_desc,
                  }
                end
                res = { status: 200, message: MSG_SUCCESS, categoryOffers: allOffers || [] }
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
              stores = CouponStore.active.all
              stores.each do |store|
                couponStores << {
                  id: store.id,
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
              storeDetail = CouponStore.active.find_by(id: params[:storeId])
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
                  shareUrl: "#{BASE_URL}/invite/#{params[:userId]}",
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

      resource :profile do
        before { api_params }

        params do
          use :common_params
        end

        post do
          begin
            user = valid_user(params[:userId], params[:securityToken])
            if user.present?
              profileData = {
                name: user.social_name,
                email: user.social_email,
                phone: user.phone || "",
                earningSince: user.created_at.strftime("%Y"),
                coinsEarned: user.wallet_balance.to_s,
                redeemAmount: (user.wallet_balance.to_f / 100).to_s,
                offersTried: 10.to_s,
                referrals: 5.to_s,
                privacyPolicy: "#{BASE_URL}/privacy.html",
                termsAndConditions: "#{BASE_URL}/terms_n_conditions.html",
                help: "www.google.com",
              }
              res = { status: 200, message: MSG_SUCCESS, profileData: profileData || {} }
              LogsHelper.logs(res, request)
              return res
            else
              res = { status: 500, message: "User Not Found" }
              LogsHelper.logs(res, request)
              return res
            end
          rescue Exception => e
            log = "API Exception - #{Time.now} - profile - #{params.inspect} - Error - #{e}"
            Rails.logger.info log
            LogsHelper.logs(log, request)
            { status: 200, message: MSG_ERROR, error: e }
          end
        end
      end

      resource :offerClicked do
        before { api_params }

        params do
          use :common_params
          requires :offerId, type: String, allow_blank: false
        end

        post do
          begin
            user = valid_user(params[:userId], params[:securityToken])
            if user.present?
              coupon_offer = CouponOffer.find(params["offerId"].to_i)
              offer_action_url = coupon_offer.action_url

              if (offer_action_url.include? "{clk-id}") || (offer_action_url.include? "{ga-id}")
                uuid = SecureRandom.uuid
                uuid = uuid.insert(-1, "-#{coupon_offer.id}-#{user.id}")
                offer_action_url = offer_action_url.gsub("{clk-id}", "#{uuid}") if offer_action_url.include? "{clk-id}"
                offer_action_url = offer_action_url.gsub("{ga-id}", "#{user.advertising_id}") if offer_action_url.include? "{ga-id}"
              end
              res = { status: 200, message: MSG_SUCCESS, actionType: "web", actionUrl: offer_action_url }
              LogsHelper.logs(res, request)
              return res
            else
              res = { status: 500, message: "User Not Found" }
              LogsHelper.logs(res, request)
              return res
            end
          rescue Exception => e
            log = "API Exception - #{Time.now} - offer Clicked - #{params.inspect} - Error - #{e}"
            Rails.logger.info log
            LogsHelper.logs(log, request)
            { status: 200, message: MSG_ERROR, error: e }
          end
        end
      end

      resource :updateProfile do
        before { api_params }

        params do
          use :common_params
          requires :name, type: String, allow_blank: true
          requires :phone, type: String, allow_blank: true
        end

        post do
          begin
            user = valid_user(params[:userId], params[:securityToken])
            if user.present?
              if params[:name].blank? && params[:phone].blank?
                res = { status: 500, message: MSG_SUCCESS, success: true }
                LogsHelper.logs(res, request)
                return res
              elsif params[:name].blank?
                user.update(social_name: user.social_name, phone: params[:phone])
                res = { status: 200, message: MSG_SUCCESS, success: true }
                LogsHelper.logs(res, request)
                return res
              else
                user.update(social_name: params[:name], phone: params[:phone])
                res = { status: 200, message: MSG_SUCCESS, success: true }
                LogsHelper.logs(res, request)
                return res
              end
              res = { status: 200, message: MSG_SUCCESS, success: true }
              LogsHelper.logs(res, request)
              return res
            else
              res = { status: 500, message: "User Not Found" }
              LogsHelper.logs(res, request)
              return res
            end
          rescue Exception => e
            log = "API Exception - #{Time.now} - updateProfile - #{params.inspect} - Error - #{e}"
            Rails.logger.info log
            LogsHelper.logs(log, request)
            { status: 200, message: MSG_ERROR, error: e }
          end
        end
      end

      resource :notifications do
        before { api_params }

        params do
          use :common_params
        end

        post do
          begin
            user = valid_user(params[:userId], params[:securityToken])
            if user.present?
              notifications = []
              Notification.all.order(created_at: :desc).limit(20).each do |notification|
                notifications << {
                  offerId: notification.coupon_offer.id,
                  title: notification.title,
                  subtitle: notification.subtitle,
                  image: notification.image_url,
                  date: notification.created_at.strftime("%d/%m/%Y"),
                }
              end
              res = { status: 200, message: MSG_SUCCESS, notifications: notifications || {} }
              LogsHelper.logs(res, request)
              return res
            else
              res = { status: 500, message: "User Not Found" }
              LogsHelper.logs(res, request)
              return res
            end
          rescue Exception => e
            log = "API Exception - #{Time.now} - notifications - #{params.inspect} - Error - #{e}"
            Rails.logger.info log
            LogsHelper.logs(log, request)
            { status: 200, message: MSG_ERROR, error: e }
          end
        end
      end

      resource :invite do
        before { api_params }

        params do
          use :common_params
        end

        post do
          begin
            user = valid_user(params[:userId], params[:securityToken])
            if user.present?
              inviteData = {
                referCode: user.refer_code,
                referralEarning: 500.to_s,
                helpUrl: "www.google.com",
                inviteFbUrl: "https://couponhub.app/invite/#{user.refer_code}/?by=facebook",
                inviteWhatsappUrl: "https://couponhub.app/invite/#{user.refer_code}/?by=whatsapp",
                inviteTelegramUrl: "https://couponhub.app/invite/#{user.refer_code}/?by=telegram",
                inviteOtherUrl: "Download CouponHub App and Get Free Paypal/Paytm Cash for Coupons, Offers & Games. Click here: https://couponhub.app/invite/#{user.refer_code}/?by=other",
              }
              res = { status: 200, message: MSG_SUCCESS, inviteData: inviteData || {} }
              LogsHelper.logs(res, request)
              return res
            else
              res = { status: 500, message: "User Not Found" }
              LogsHelper.logs(res, request)
              return res
            end
          rescue Exception => e
            log = "API Exception - #{Time.now} - invite - #{params.inspect} - Error - #{e}"
            Rails.logger.info log
            LogsHelper.logs(log, request)
            { status: 200, message: MSG_ERROR, error: e }
          end
        end
      end

      resource :wallet do
        before { api_params }

        params do
          use :common_params
        end

        post do
          begin
            user = valid_user(params[:userId], params[:securityToken])
            if user.present?
              withdrawls = []
              transactions = []
              withdrawlHistory = user.transaction_histories.where(trans_type: "withdrawl").limit(10)
              transactionHistory = user.transaction_histories.where(trans_type: "transaction").limit(10)
              withdrawlHistory.each do |withdrawl|
                withdrawls << {
                  title: withdrawl.name,
                  coins: withdrawl.coins.to_s,
                  date: withdrawl.created_at.strftime("%Y-%m-%d"),
                }
              end
              transactionHistory.each do |transaction|
                transactions << {
                  title: transaction.name,
                  coins: transaction.coins.to_s,
                  date: transaction.created_at.strftime("%Y-%m-%d"),
                }
              end
              walletData = {
                coins: user.wallet_balance.to_s,
                withdrawlLimit: "500",
                conversion: (user.wallet_balance.to_f / 100).to_s,
                transactionHistory: transactions || [],
                withdrawlHistory: withdrawls || [],
              }
              res = { status: 200, message: MSG_SUCCESS, walletData: walletData || {} }
              LogsHelper.logs(res, request)
              return res
            else
              res = { status: 500, message: "User Not Found" }
              LogsHelper.logs(res, request)
              return res
            end
          rescue Exception => e
            log = "API Exception - #{Time.now} - invite - #{params.inspect} - Error - #{e}"
            Rails.logger.info log
            LogsHelper.logs(log, request)
            { status: 200, message: MSG_ERROR, error: e }
          end
        end
      end

      resource :redeemList do
        before { api_params }

        params do
          use :common_params
        end

        post do
          begin
            user = valid_user(params[:userId], params[:securityToken])
            if user.present?
              data = {}
              data[:totalCoins] = user.wallet_balance.to_s
              data[:conversion] = (user.wallet_balance.to_f / 100).to_s
              data[:withdrawlLimit] = "500"
              payout_list = []
              Payout.all.each do |payout|
                payout_list << {
                  payoutId: payout.id,
                  payoutName: payout.payout_name,
                  payoutImageUrl: payout.payout_img_url,
                  payoutCoins: payout.payout_amount.split(","),
                  payoutAmounts: payout.payout_amount.split(",").map { |coin| (coin.to_f / 100).to_s },
                }
              end
              data[:payoutList] = payout_list
              res = { status: 200, message: "Success", data: data }
              LogsHelper.logs(res, request)
              return res
            else
              res = { status: 500, message: "User Not Found" }
              LogsHelper.logs(res, request)
              return res
            end
          rescue Exception => e
            log = "API Exception - #{Time.now} - invite - #{params.inspect} - Error - #{e}"
            Rails.logger.info log
            LogsHelper.logs(log, request)
            { status: 200, message: MSG_ERROR, error: e }
          end
        end
      end

      resource :redeemSubmit do
        before { api_params }

        params do
          use :common_params
          requires :upiId, type: String, allow_blank: false
          requires :phone, type: String, allow_blank: false
          requires :coins, type: String, allow_blank: false
          requires :payoutId, type: String, allow_blank: false
        end

        post do
          begin
            user = valid_user(params[:userId], params[:securityToken])
            if user.present?
              if user.wallet_balance.to_f < params[:coins].to_f
                res = { status: 500, message: MSG_ERROR, error: "Insufficient Balance" }
                LogsHelper.logs(res, request)
                return res
              else
                wallet_balance = user.wallet_balance.to_f - params[:coins].to_f
                user.update(wallet_balance: wallet_balance)
                user.redeem_histories.create(upi_id: params[:upiId], phone: params[:phone], coins: params[:coins].to_f, amount: (params[:coins].to_f / 100).to_s, payout_id: params[:payoutId])
                user.transaction_histories.create(trans_type: "withdrawl", name: "Withdrawl Request", coins: params[:coins])
                res = { status: 200, message: MSG_SUCCESS, success: true }
                LogsHelper.logs(res, request)
                return res
              end
            else
              res = { status: 500, message: "User Not Found" }
              LogsHelper.logs(res, request)
              return res
            end
          rescue Exception => e
            log = "API Exception - #{Time.now} - invite - #{params.inspect} - Error - #{e}"
            Rails.logger.info log
            LogsHelper.logs(log, request)
            { status: 200, message: MSG_ERROR, error: e }
          end
        end
      end
    end
  end
end
