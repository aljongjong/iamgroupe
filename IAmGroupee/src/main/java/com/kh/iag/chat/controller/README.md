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
public String getBox(String userNo) throws Exception {
	StringBuffer result = new StringBuffer("");
	result.append("{\"result\":[");

	List<ChatDto> chatList = getChatListBox(userNo);
	List<UserDto> list = service.selectUserList();
	for(int i = 0; i < list.size(); i++) {
		for(int j = 0; j < chatList.size(); j++) {
			if(list.get(i).getUserNo().equals(chatList.get(j).getFromId()) && !userNo.equals(chatList.get(j).getFromId())) {
				chatList.get(j).setName(list.get(i).getName());
				chatList.get(j).setDepartmentName(list.get(i).getDepartmentName());
				chatList.get(j).setPositionName(list.get(i).getPositionName());
			} else if(list.get(i).getUserNo().equals(chatList.get(j).getToId()) && !userNo.equals(chatList.get(j).getToId())) {
				chatList.get(j).setName(list.get(i).getName());
				chatList.get(j).setDepartmentName(list.get(i).getDepartmentName());
				chatList.get(j).setPositionName(list.get(i).getPositionName());
			}
		}
	}

	if(chatList.size() == 0) return "";
	for(int i = 0; i < chatList.size(); i++) {

		String unread = "";
		if(userNo.equals(chatList.get(i).getToId())) {
			unread = service.selectChatUnreadedEsp(chatList.get(i));
			if(unread.equals("0")) unread = "";
		}

		result.append("[{\"value\": \"" + chatList.get(i).getFromId() + "\"},");
		result.append("{\"value\": \"" + chatList.get(i).getToId() + "\"},");
		result.append("{\"value\": \"" + chatList.get(i).getDepartmentName() + " " + chatList.get(i).getName() + " " + chatList.get(i).getPositionName() + "\"},");
		result.append("{\"value\": \"" + chatList.get(i).getChatContent() + "\"},");
		result.append("{\"value\": \"" + chatList.get(i).getChatTime() + "\"},");
		result.append("{\"value\": \"" + unread + "\"}]");
		if(i != chatList.size() - 1) result.append(",");
	}
	result.append("], \"last\":\"" + chatList.get(chatList.size() - 1).getChatId() + "\"}");
	return result.toString();
}
```

## <대화창>
```java

```
