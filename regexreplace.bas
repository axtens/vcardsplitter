
Sub RegexReplace(pattern As String, Text As String, Replacement As String) As String
    Dim m As Matcher
    m = Regex.Matcher(pattern, Text)
    Dim r As Reflector
    r.Target = m
    Return r.RunMethod2("replaceAll", Replacement, "java.lang.String")
End Sub

Sub PlainText (HTML As String) As String
	HTML = RegexReplace("/<\s*br\/*>/gi", HTML, CRLF)
	HTML = RegexReplace("/<\s*a.*href=" & QUOTE & "(.*?)" & QUOTE & ".*>(.*?)<\/a>/gi", HTML, " $2 (Link->$1) ")
	HTML = RegexReplace("/<\s*\/*.+?>/ig", HTML, CRLF)
	HTML = RegexReplace("/ {2,}/gi", HTML, " ")
	HTML = RegexReplace("/\n+\s*/gi", HTML, CRLF & CRLF)
	Return HTML
End Sub