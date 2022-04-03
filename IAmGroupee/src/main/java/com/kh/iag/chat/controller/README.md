# 👾 사내 메신저 사용자 주요 로직 

## <대화 리스트>
```java
public List<ChatDto> getChatListBox(String userNo) throws Exception {

	List<ChatDto> chatList = service.selectChatListBox(userNo);

	for(ChatDto c : chatList) {
		int chatTime = Integer.parseInt(c.getChatTime().substring(11, 13)) + 9;
		String timeType = "오전";
		if(chatTime >= 12) {
			timeType = "오후";
			chatTime -= 12;
		}
		c.setChatTime(c.getChatTime().substring(0, 11) + " " + timeType + " " + chatTime + ":" + c.getChatTime().substring(14, 16));
	}

	for(int i = 0; i < chatList.size(); i++) {
		ChatDto x = chatList.get(i);
		for(int j = 0; j < chatList.size(); j++) {
			ChatDto y = chatList.get(j);
			if(x.getFromId().equals(y.getToId()) && x.getToId().equals(y.getFromId())) {
				if(x.getChatId() < y.getChatId()) {
					chatList.remove(x);
					i--;
					break;
				} else {
					chatList.remove(y);
					j--;
				}
			}
		}
	}

	return chatList;
}
```

## <대화 상대선택>
```java

```

## <대화창>
```java

```
