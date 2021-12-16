db: {
    nftOwners{
        ethPrice: int,
        link: String,
        userName; String,
        number: int
        uid: uid,
        userImageURL: String,
    }
    posts{
        audioURL: String,
        bookmarks: [{
            createdAt: TimeStamp,
            uid: String,
        }],
        bookmarksCount: int,
        comments: [{
            comment: String,
            commentId: String,
            createdAt: TimeStamp,
            ipv6: String
            isNFTicon: false,
            isOfficial: false,
            likesUids: [ String ],
            score: int,
            uid: String,
            userDocId: String,
            userName: String,
            userImageURL: String,
        }],
        commentsState: String('open','isLocked','onlyFollowingUsers')
        createdAt: TimeStamp,
        genre: String
        imageURL: String,
        impression: int,
        ipv6: String,
        isNFTicon: bool,
        isOfficial: bool,
        isPlayedCount: int,
        likes: [{
            createdAt: TimeStamp,
            uid: String,
        }],
        likesCount: int,
        link: String
        noDisplayUids: list,
        postId: String,
        score: int,
        title: String,
        uid: String,
        updatedAt: TimeStamp,
        userDocId: String,
        userImageURL: String,
        userName: String
    }
    replys{
        elementId: String,
        elementState: string [ comment ],
        createdAt: TimeStamp,
        ipv6: String
        isNFTicon: bool,
        isOfficial: bool,
        likesUids: [],
        likesUidsCount: int
        reply: String,
        replyId; String,
        score: int,
        uid: String,
        userDocId: String,
        userName: String,
        userImageURL: String,
    }
    users{
        birthDay: TimeStamp,
        blockingUids: [ String ],
        bookmarks: [{
            createdAt: TimeStamp,
            postId: String,
        }],
        commentNotifications: [{
            'comment': String,
            'createdAt': TimeStamp,
            'isNFTicon': bool,
            'isOfficial':bool,
            'notificationId': String,
            'postId': notificationId,
            'postTitle': String,
            'uid': String,
            'userDocId': String,
            'userName': String,
            'userImageURL': String,
        }],
        createdAt: TimeStamp,
        description: String,
        dmState: ["onlyFollowingAndFollowed","open"],
        followNotifications: [],
        followerUids:[
            String
        ],
        followingUids: [
            String
        ],
        gender: String[male,female,others,noAnswer],
        imageURL: String,
        isAdmin: bool,
        isNFTicon: bool,
        isKeyAccount: bool,
        isOfficial: bool,
        isSubAdmin: bool,
        isSubscribed: bool,
        joiningCommunityIds,List<String>,
        language: String ja,en,
        likedComments:[{
            commentId: String,
            createdAt: TimeStamp,
        }],
        likeNotifications: [],
        likedReplys: [{
            'createdAt': TimeStamp,
            'likedReplyId': String,
        }],
        likes: [{
            createdAt: TimeStamp,
            likedPostId: String,
        }],
        link: String,
        mutesReplyIds: List<String>,
        mutesUids: List<String>,
        mutesCommentIds: List<String>,
        mutesIpv6s: List<String>,
        mutesPostIds: List<String>,
        noDisplayWordsOfComments: List<String>,
        noDisplayWordsOfMyPost: List<String>,
        otherLinks: List<String>,
        readNotificationIds: [ String ],
        readPosts: [{
            'createdAt': TimeStamp,
            'durationInt': int,
            'postId': String,
        }],
        recommendState: 'recommendable',
        replyNotifications: [{
            comment: String,
            elementId: String,
            createdAt: TimeStamp,
            'isNFTicon': bool,
            'isOfficial':bool,
            notificationId: String,
            reply: String,
            uid: String,
            userDocId: String,
            userName: String,
            userImageURL: String,
        }],
        score: int,
        searchHistorys: List<String>,
        subUserName: String,
        uid: String,
        updatedAt: String,
        userName: String,
        walletAddress: String,
    }
}