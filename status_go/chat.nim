import segfaults


type
  StatusGoChat* = object
    active: cint
    id: cstring
    name: cstring
    chatType*: cint
    color: cstring
    deletedAtClockValue: culonglong
    description: cstring
    emoji: cstring
    identicon: cstring
    lastClockValue: culonglong
    muted: cint
    timestamp: clonglong 
    unviewedMentionsCount: cint
    unviewedMessagesCount: cint

  StatusGoChatArray* = object
    len*: cint
    data*: ptr UncheckedArray[StatusGoChat]

  ChatType* {.pure.}= enum
    Unknown = 0,
    OneToOne = 1, 
    Public = 2,
    PrivateGroupChat = 3,
    Profile = 4,
    Timeline = 5
    CommunityChat = 6

  Chat* = object
    active*: bool
    id*: string
    name*: string
    chatType*: ChatType
    color*: string
    deletedAtClockValue*: uint64
    description*: string
    emoji*: string
    identicon*: string
    lastClockValue*: uint64
    muted*: bool
    timestamp*: int64 
    unviewedMentionsCount*: int
    unviewedMessagesCount*: int

proc statusgo_chats(): StatusGoChatArray {.importc: "Chats".}
proc c_free*(p: pointer) {.importc: "free", header: "<stdlib.h>".}

proc newChat*(goChat: StatusGoChat): Chat =
  result.active = goChat.active.bool
  result.id = $goChat.id
  result.name = $goChat.name
  result.chatType = ChatType(goChat.chatType)
  result.color = $goChat.color
  result.deletedAtClockValue = goChat.deletedAtClockValue
  result.description = $goChat.description
  result.emoji = $goChat.emoji
  result.identicon = $goChat.identicon
  result.lastClockValue = goChat.lastClockValue
  result.muted = goChat.muted.bool
  result.timestamp = goChat.timestamp
  result.unviewedMentionsCount = goChat.unviewedMentionsCount
  result.unviewedMessagesCount = goChat.unviewedMessagesCount
  
  c_free(goChat.id)
  c_free(goChat.name)
  c_free(goChat.color)
  c_free(goChat.description)
  c_free(goChat.emoji)
  c_free(goChat.identicon)


proc chats*(): seq[Chat] =
  let chatArr = statusgo_chats()
  if chatArr.len == 0:
    return

  for i in 0 .. chatArr.len - 1: 
    result.add newChat(StatusGoChat(chatArr.data[i]))

  c_free(chatArr.data)
