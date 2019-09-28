Type=StaticCode
Version=2.18
B4J=true
@EndOfDesignText@

Sub Process_Globals
	Dim i As Int
	Dim Str As JStringFunctions
	Str.Initialize
	
	Dim cardLists As List
	cardLists.Initialize
	Dim DOTALL As Int = 0x20		
	Dim card As String
	Dim Cards As Map
	Cards.Initialize
	
	Dim FNMatcher As Matcher 
	Dim FNPattern As String = "^FN:(.*?)$"
	Dim FNName As String
	Dim Block As String
	Dim c As Map
	c.Initialize
	
	Dim res As Matcher
		
End Sub

'NOTES:
'	the current technique for extracting the components doesn't work well. 
'	Let's try grabbing using regular expressions or an implementation of
' 	Between()

Sub Process( Filename As String) As Object
	If  File.Exists("", Filename) = False Then
		Log("Could not find " & Filename )
		Return Null
	End If
	Log("Splitting " & Filename)

	'StartMessageLoop
	Block = File.ReadString("",Filename)
	
	Dim CardPattern As String = "^BEGIN:VCARD.*?END:VCARD$"
	res = Regex.Matcher2(CardPattern,Regex.MULTILINE + DOTALL,Block)
	Do While res.Find
		card = res.match
		FNMatcher = Regex.Matcher2(FNPattern,Regex.MULTILINE + DOTALL,card)
		If FNMatcher.Find Then
			FNName = FNMatcher.Group(1)
		Else
			FNName = "Stuff"
		End If
		If Cards.ContainsKey(FNName) Then
			If Cards.Get(FNName) <> card Then
				For i = 2 To 10
					If Cards.ContainsKey(FNName & "#" & (i)) = False Then
						Cards.Put(FNName & "#" & (i),card)
						Exit
					End If
				Next
			End If
		Else
			Cards.Put(FNName, card)
		End If
	Loop
	
	For Each k As String In Cards.Keys
	
		Dim vc As Map
		vc.Initialize

		IfFound(Cards.Get(k),"VERSION:",vc)
		IfFound(Cards.Get(k),"FN:",vc)
		IfFound(Cards.Get(k),"N:",vc)
		IfFound(Cards.Get(k),"EMAIL;PREF;X-other:",vc)
		IfFound(Cards.Get(k),"EMAIL;X-other:",vc)
		IfFound(Cards.Get(k),"EMAIL;PREF:",vc)
		IfFound(Cards.Get(k),"EMAIL:",vc)
		IfFound(Cards.Get(k),"EMAIL;PREF;WORK:",vc)
		IfFound(Cards.Get(k),"EMAIL;PREF;HOME:",vc)
		IfFound(Cards.Get(k),"TEL;CELL;PREF:",vc)
		IfFound(Cards.Get(k),"TEL;CELL:",vc)
		IfFound(Cards.Get(k),"TEL;HOME;PREF:",vc)
		IfFound(Cards.Get(k),"TEL;HOME:",vc)
		IfFound(Cards.Get(k),"TEL;VOICE;PREF:",vc)
		IfFound(Cards.Get(k),"TEL;VOICE:",vc)
		IfFound(Cards.Get(k),"TEL;X-VOICE:",vc)
		IfFound(Cards.Get(k),"TEL;X-VOICE;PREF:",vc)
		IfFound(Cards.Get(k),"TEL;X-other:",vc)
		IfFound(Cards.Get(k),"TEL;X-other;PREF:",vc)
		IfFound(Cards.Get(k),"ADR;HOME:",vc) 
		IfFound(Cards.Get(k),"ADR;WORK:",vc) 
		IfFound(Cards.Get(k),"ADR:",vc) 
		IfFound(Cards.Get(k),"URL;",vc)
		IfFound(Cards.Get(k),"NOTE:",vc)
		IfFound(Cards.Get(k),"X-ANDROID-CUSTOM:",vc)
		IfFound(Cards.Get(k),"X-JABBER;HOME:",vc)
		IfFound(Cards.Get(k),"X-JABBER:",vc)
		IfFound(Cards.Get(k),"X-JABBER;WORK:",vc)
		
		If Main.cardMap.ContainsKey(vc.Get("FN:")) Then
			Dim tempMap As Map = Main.cardmap.Get(vc.get("FN:"))
			For Each vcKey As String In vc.Keys
				tempMap.Put(vcKey,vc.Get(vcKey))
			Next
			Main.cardMap.Put(vc.Get("FN:"),tempMap)
		Else
			Main.cardMap.Put(vc.Get("FN:"),vc)
		End If
	Next
	Return Null
End Sub

Sub IfFound(haystack As String, needle As String, theMap As Map) As Object
	Dim m As Matcher
	m = Regex.Matcher2("^" & needle & "(.*?)$",Regex.MULTILINE+Regex.CASE_INSENSITIVE,haystack)
	If m.Find Then
		theMap.Put(needle, m.Group(1))
	End If
	Return Null
End Sub

