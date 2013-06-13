<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %>
<%
    if (Session["UserData"] != null) {
%>
        Добро пожаловать<b><%: Page.User.Identity.Name %></b>!
        [ <%: Html.ActionLink("Выход", "LogOff", "Admin") %> ]
<%
    }
    else {
%> 
        [ <%: Html.ActionLink("Вход", "Login", "Admin") %> ]
<%
    }
%>
<a href="http://tourminal.ru/" target="_new">[http://tourminal.ru/]</a>