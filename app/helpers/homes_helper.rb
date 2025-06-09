module HomesHelper
    def no_scroll_lock?
        params[:mode] == "friends" && !@show_friend_search
    end
end
# URLパラメータが?mode=friendsの時
# インスタンス変数@show_friend_searchがfalseまたはnilの時
# 上記の二つを満たす時だけスクロールロック
